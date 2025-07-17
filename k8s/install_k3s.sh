#!/bin/bash
set -e

# Install k3s and any relevant GPU support software
#
# Usage:
#   install_k3s.sh [agent|server] [options]
#
# Specify [agent] when adding an agent node.
# Specify [server] if adding a server node.
#
# Options:
#
#   --token SomeSecretToken
#     A secret token for the cluster. All nodes must use this token.
#
#   --server https://example.com:6443
#     The URL of the cluster's server.
#
#   --cluster-init
#     Create a new cluster.
#
# Examples:
#   Install and start a new cluster
#     install_k3s.sh server --token xxx --cluster-init
#
#   Install as an agent joining an existing cluster
#     install_k3s.sh agent --token xxx --server https://example.com:6443

info() {
    echo '[INFO] ' "$@"
}
warn() {
    echo '[WARN] ' "$@" >&2
}
fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# Define needed environment variables
setup_env() {
    # Use sudo if we are not already root
    SUDO=sudo
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=
    fi
}

# Check if the host has a Nvidia GPU
has_gpu_nvidia() {
	gpu=$(lspci | grep -i '.*vga.*nvidia.*')
	if [ -n "$gpu" ]; then
		info "Found GPU $gpu"
		return 0
	fi

	# Didn't find a Nvidia GPU. Return false.
	return 1
}

# Install the Nvidia container toolkit
install_nvidia_container_toolkit() {
	# From the Nvidia Container Toolkit documentation
	# - https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
	$SUDO gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg ./nvidia/nvidia-container-toolkit-keyring.gpg
	$SUDO cp ./nvidia/nvidia-container-toolkit.list /etc/apt/sources.list.d/nvidia-container-toolkit.list
	$SUDO apt-get update
	$SUDO apt-get install -y nvidia-container-toolkit
}

check_gpu() {
	# Install the appropriate GPU plugins, if found
	if has_gpu_nvidia; then
		GPU_TYPE=nvidia
	fi
}

# Install k8s resources to use the Nvidia GPU
install_k8s_nvidia_resources() {
	$SUDO nvidia-ctk runtime configure --runtime=containerd

	info "Verifying containerd sees GPU..."
	# Be sure this verison matches what's in ./k8s/nvidia/gpu-test.yaml
	cudaVer=11.4.3
	cudaImg=docker.io/nvidia/cuda:${cudaVer}-base-ubuntu20.04
	$SUDO ctr image pull "$cudaImg"
	$SUDO ctr run --rm --gpus 0 -t "$cudaImg" cuda-${cudaVer} nvidia-smi

	kubectl apply -f ./nvidia/resources.yaml
}

# Install k3s and tools
install_k3s() {
	check_gpu

	# Trying https://radicalgeek.co.uk/pi-cluster/adding-a-gpu-node-to-a-k3s-cluster/

	[ "$GPU_TYPE" == "nvidia" ] && install_nvidia_container_toolkit

	# Install k3s
	k3sVersion=v1.31.6+k3s1
	k8sGroup=k8s

	info "Creating k8s group and adding $USER..."
	$SUDO groupadd -f --system "$k8sGroup" --users "$USER"

	# Configure image storage, container files, and persistent volumes to be
	# backed by a larger drive instead of using the OS directories.
	# - https://github.com/k3s-io/k3s/issues/2068#issuecomment-1374672584
	mntDir=/mnt/k8s

	info "Setting up kubelet filesystem..."
	kubeletDir="${mntDir}/kubelet"
	$SUDO mkdir -p "$kubeletDir"

	info "Setting up containerd root filesystem..."
	C_ROOT_DIR_OLD=/var/lib/rancher/k3s/agent
	C_ROOT_DIR_NEW="${mntDir}/containerd-root/containerd"
	$SUDO mkdir -p "$C_ROOT_DIR_NEW" "$C_ROOT_DIR_OLD"
	$SUDO ln -sf "$C_ROOT_DIR_NEW" "$C_ROOT_DIR_OLD"

	info "Setting up containerd state filesystem..."
	C_STATE_DIR_OLD=/run/k3s
	C_STATE_DIR_NEW="${mntDir}/containerd-state/containerd"
	$SUDO mkdir -p "$C_STATE_DIR_NEW" "$C_STATE_DIR_OLD"
	$SUDO ln -sf "$C_STATE_DIR_NEW" "$C_STATE_DIR_OLD"

	info "Setting up local-path-provisioner filesystem..."
	PV_DIR_OLD=/var/lib/rancher/k3s
	PV_DIR_NEW="${mntDir}/local-path-provisioner/storage"
	$SUDO mkdir -p "$PV_DIR_NEW" "$PV_DIR_OLD"
	$SUDO ln -sf "$PV_DIR_NEW" "$PV_DIR_OLD"

	info "Installing single-node k3s..."
	$SUDO INSTALL_K3S_VERSION="$k3sVersion" \
		K3S_KUBECONFIG_MODE=640 \
		K3S_KUBECONFIG_GROUP=k8s \
		./k3sInstaller.sh \
			"$@" \
			--write-kubeconfig-group k8s \
			--write-kubeconfig-mode 640 \
			--kubelet-arg "root-dir=${kubeletDir}"

	# k3s installer sets to 644 by default, which exposes the token
	$SUDO chmod 640 /etc/systemd/system/k3s.service

	[ "$GPU_TYPE" == "nvidia" ] && install_k8s_nvidia_resources
}

# Start configuration
{
	setup_env
	install_k3s "$@"
	info "Restart computer to use kubectl"
}
