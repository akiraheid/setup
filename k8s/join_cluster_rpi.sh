#!/usr/bin/env bash
set -e

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
	if [ $# != 3 ]; then
		info "Configure an rpi host to join a cluster as a k8s server."
		info ""
		info "Usage:"
		info "  join_cluster_rpi.sh HOSTNAME SERVER_URL TOKEN"
		info ""
		info "Example:"
		info "  join_cluster_rpi.sh rpi01 https://server:6443 my-secret-token"
		info ""
		fatal "Expected hostname, server URL, and token as arguments."
	fi

	HOSTN=$1
	SERVER_URL=$2
	CLUSTER_TOKEN=$3
	THISD=$(dirname "$(readlink -f "$0")")
}

copy_install_files() {
	rsync -r "${THISD}"/* "pi@${HOSTN}:/home/pi/"
}

sshcmd() {
	# Warns about expanding on the client side, which is desired.
	# shellcheck disable=SC2029
	ssh "pi@${HOSTN}" "$@"
}

install_k3s() {
	info "Setting up cgroups"
	sshcmd sudo bash ./rpi_enable_cgroup.sh

	info "Sleep in case rpi was rebooted"
	sleep 10s

	info "Install k3s"
	sshcmd ./install_server.sh --token "${CLUSTER_TOKEN}" --server "${SERVER_URL}"
}

# Run the installer
{
	setup_env "$@"
	copy_install_files
	install_k3s
}
