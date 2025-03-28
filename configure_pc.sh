#!/bin/bash
set -e

# --- helper functions for logs ---
info()
{
    echo '[INFO] ' "$@"
}
warn()
{
    echo '[WARN] ' "$@" >&2
}
fatal()
{
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# --- set up environment ---
setup_env() {
    # use sudo if we are not already root
    SUDO=sudo
    if [ $(id -u) -eq 0 ]; then
        SUDO=
    fi
}

# --- install k8s ---
install_k8s() {
	./k8s/install.sh

	$SUDO addgroup k8s
	$SUDO adduser $USER k8s

	$SUDO chown -R root:k8s /etc/rancher/k3s
	$SUDO chmod 640 /etc/rancher/k3s/k3s.yaml
}

# --- configure system ---
{
	setup_env
	install_k8s
	info "Restart system"
}
