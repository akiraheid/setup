#!/bin/bash
# Set up PC environment
set -e

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

# Update system
update_system() {
	info "Updating system..."
	$SUDO ./bash/updateSystem
	info "System updated"
}

# Install bash settings
install_bash_settings() {
	info "Installing bash settings and tools..."
	date=$(date +%Y%m%d-%H%M%S)
	cp --suffix="${date}" ./bash/bashrc ~/.bashrc
	cp --suffix="${date}" ./bash/bash_aliases ~/.bash_aliases
	cp --suffix="${date}" ./bash/bash_functions ~/.bash_functions
	cp --suffix="${date}" ./bash/bash_profile ~/.bash_profile
	cp --suffix="${date}" ./bash/profile ~/.profile

	d=${HOME}/.local/bin
	mkdir -p "${d}"
	cp --suffix="${date}" ./bin/oil "${d}/oil"
	cp --suffix="${date}" ./bin/syncthing "${d}/syncthing"
	info "Installed bash settings and tools"
}

# Install podman and settings
install_podman() {
	info "Installing podman and settings..."
	$SUDO apt-get install -y podman
	info "Installed podman and settings"
}

# Install vim and settings
install_vim() {
	info "Installing vim..."
	$SUDO apt-get -y install vim
	date=$(date +%Y%m%d-%H%M%S)
	cp --suffix="${date}" ./vim/vimrc ~/.vimrc
	info "Installed vim and vim configuration"

	autoloadDir=${HOME}/.vim/autoload
	bundleDir=${HOME}/.vim/bundle
	mkdir -p "$autoloadDir" "$bundleDir"

	info "Installing vim plugins..."
	pathogen=pathogen.vim
	if [ ! -f "${autoloadDir}/${pathogen}" ]; then
		cp "./vim/${pathogen}" "${autoloadDir}/${pathogen}"
	fi
	tmpdir=$(mktemp -d)
	cp ./vim/plugins.sha256 "${tmpdir}/"
	pushd "$tmpdir"

	cfn=syntastic.tar.gz
	v=3.10.0
	if [ ! -f "$cfn" ]; then
		wget -O "$cfn" "https://github.com/vim-syntastic/syntastic/archive/refs/tags/${v}.tar.gz"
	fi

	sha256sum -c plugins.sha256

	info "Installing syntastic"
	tar -xf "$cfn" -C "${bundleDir}/"

	pushd "$bundleDir"
	mv "syntastic-${v}" "syntastic"
	popd # bundleDir

	popd # tmpdir
	rm -r "$tmpdir"
	info "Installed vim plugins"
}

# Install tmux and settings
install_tmux() {
	info "Installing tmux..."
	$SUDO apt-get -y install tmux
	info "Installed tmux and tmux configuration"
}

# Install decoaps and dependencies
install_decoaps() {
	info "Installing decoaps..."
	image=x11docker/xserver
	podman pull "docker.io/${image}:latest"
	sha=$(podman images | grep "${image}" | sed 's/\s\+/ /g' | cut -d ' ' -f 3)
	expected=b97c942d93c7
	if [ "$sha" != "${expected}" ]; then
		fatal "Hash of ${image} was '${sha}' instead of expected '${expected}'"
	fi

	# Work in the repos directory, since that's where I'll edit things anyway
	mkdir -p "${HOME}/repos"
	pushd "${HOME}/repos"

	git clone https://github.com/akiraheid/containerfiles.git
	pushd containerfiles
	./install black
	./install eslint
	./install gnucash
	./install keepassxc
	./install obsidian
	./install prettier
	./install pylint
	./install shellcheck
	./install signal
	popd # containerfiles
	popd # ~/repos
	info "Installed decoaps"
}

#setup_firewall() {
#    # Regardless of how dynamic your network environment may be, it is still
#    # useful to be familiar with the general idea behind each of the predefined
#    # zones for firewalld. In order from least trusted to most trusted, the
#    # predefined zones within firewalld are:
#    # drop: Any incoming network packets are dropped, there is no reply. Only
#    #       outgoing network connections are possible.
#    # block: Any incoming network connections are rejected with an
#    #        icmp-host-prohibited message for IPv4 and icmp6-adm-prohibited
#    #        for IPv6. Only network connections initiated within this system
#    #        are possible.
#    # public: For use in public areas. You do not trust the other computers on
#    #         networks to not harm your computer. Only selected incoming
#    #         connections are accepted.
#    # external: For use on external networks with IPv4 masquerading enabled
#    #           especially for routers. You do not trust the other computers on
#    #           networks to not harm your computer. Only selected incoming
#    #           connections are accepted.
#    # dmz: For computers in your demilitarized zone that are publicly-accessible
#    #      with limited access to your internal network. Only selected incoming
#    #      connections are accepted.
#    # work: For use in work areas. You mostly trust the other computers on
#    #       networks to not harm your computer. Only selected incoming
#    #       connections are accepted.
#    # home: For use in home areas. You mostly trust the other computers on
#    #       networks to not harm your computer. Only selected incoming
#    #       connections are accepted.
#    # internal: For use on internal networks. You mostly trust the other
#    #           computers on the networks to not harm your computer. Only
#    #           selected incoming connections are accepted.
#    # trusted: All network connections are accepted.
#    # https://firewalld.org/documentation/zone/predefined-zones.html
#
#    apt_install('firewalld')
#
#    def firewallcmd(args):
#        run(['firewall-cmd', '--permanent'] + args, check=True)
#
#    # By default, firewalld uses the public zone and has dhcpv6-client and ssh
#    # services running. Disable these because we don't host these services on
#    # PCs.
#    firewallcmd(['--remove-service', 'dhcpv6-client'])
#    firewallcmd(['--remove-service', 'ssh'])
#}

function has_gpu_nvidia() {
	gpu=$(lspci | grep -i '.*vga.*nvidia.*')
	if [ -n "$gpu" ]; then
		info "Found GPU $gpu"
		return 0
	fi

	# Didn't find a NVIDIA GPU. Return false.
	return 1
}

# Install the NVIDIA container toolkit
function install_nvidia_container_toolkit() {
	# From the NVIDIA Container Toolkit documentation
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

# Install k8s resources to use the NVIDIA GPU
install_k8s_nvidia_resources() {
	$SUDO nvidia-ctk runtime configure --runtime=containerd

	info "Verifying containerd sees GPU..."
	# Be sure this verison matches what's in ./k8s/nvidia/gpu-test.yaml
	cudaVer=11.4.3
	cudaImg=docker.io/nvidia/cuda:${cudaVer}-base-ubuntu20.04
	$SUDO ctr image pull "$cudaImg"
	$SUDO ctr run --rm --gpus 0 -t "$cudaImg" cuda-${cudaVer} nvidia-smi

	kubectl apply -f ./k8s/nvidia/resources.yaml
	kubectl label nodes "$HOSTNAME" workload=ai
}

# Install k8s and tools
install_k8s() {
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
	INSTALL_K3S_VERSION="$k3sVersion" \
		INSTALL_K3S_EXEC="--kubelet-arg root-dir=${kubeletDir}" \
		./k8s/k3sInstaller.sh \
			--write-kubeconfig-group "$k8sGroup" \
			--write-kubeconfig-mode 640

	[ "$GPU_TYPE" == "nvidia" ] && install_k8s_nvidia_resources
}

# Start configuration
{
	setup_env
	update_system
	install_bash_settings
	install_tmux
	install_vim
	install_podman
	install_decoaps
	install_k8s
	info "Restart computer to use kubectl"
}
