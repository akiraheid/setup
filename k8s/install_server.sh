#!/bin/bash
set -e

# Install k3s as a server.
#
# Usage:
#   install_server.sh [options]
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

info() {
    echo '[INFO] ' "$@"
}

# Define needed environment variables
setup_env() {
    # Use sudo if we are not already root
    SUDO=sudo
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=
    fi
}

# Install k3s and tools
install() {
	info "Installing k3s server"
	./install_common.sh server "$@" \
		--write-kubeconfig-group k8s \
		--write-kubeconfig-mode 640

	# k3s installer sets to 644 by default, which exposes the token
	$SUDO chmod 640 /etc/systemd/system/k3s.service
}

# Start configuration
{
	setup_env
	install "$@"
}
