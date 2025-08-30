#!/bin/bash
set -e

# Install k3s as an agent.
#
# Usage:
#   install_agent.sh [options]
#
# Options:
#
#   --token SomeSecretToken
#     A secret token for the cluster. All nodes must use this token.
#
#   --server https://example.com:6443
#     The URL of the cluster's server.
#
# Examples:
#   Install and start a new cluster
#     install_k3s.sh agent --token xxx --server https://example.com:6443

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
	info "Installing k3s agent"
	./install_common.sh agent "$@"

	# k3s installer sets to 644 by default, which exposes the token
	$SUDO chmod 640 /etc/systemd/system/k3s-agent.service
	# Consider getting the important info into k3s-agent.service.env instead
	# because that seems to default to 600 even if the install command hangs
}

# Start configuration
{
	setup_env
	install "$@"
}
