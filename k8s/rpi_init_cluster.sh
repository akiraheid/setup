#!/bin/bash
set -e

# Install k3s as a server initializing a cluster.
#
# Usage:
#   rpi_init_cluster.sh TOKEN
#
# Example:
#   rpi_init_cluster.sh my-secret-token

info() {
    echo '[INFO] ' "$@"
}
fatal()
{
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# Define needed environment variables
setup_env() {
	if [ $# != 1 ]; then
		fatal "Expected token as only argument."
	fi

	CLUSTER_TOKEN=$1

    # Use sudo if we are not already root
    SUDO=sudo
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=
    fi
}

# Install k3s and tools
install_k3s() {
	$SUDO ./rpi_enable_cgroup.sh
	$SUDO ./install_server.sh --token "$CLUSTER_TOKEN" --cluster-init
}

# Start configuration
{
	setup_env "$@"
	install_k3s "$@"
	info "Restart computer to use kubectl"
}
