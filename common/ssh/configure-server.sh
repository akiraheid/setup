#!/usr/bin/env bash
# Install and configure an SSH server common to all machines
set -exuo pipefail

this_dir=$(dirname "$(readlink -f "$0")")
sudo=

# Load common functions
. "${this_dir}"/../logging.sh

check_sudo() {
	if ! [[ "$UID" ]]; then
		sudo=sudo
	fi
}

configure_firewall() {
	$sudo ufw allow ssh
}

generate_keys() {
	$sudo mkdir -p /etc/ssh

	host_key=server_ed25519
	if [ ! -f "/etc/ssh/${host_key}.pub" ]; then
		$sudo ssh-keygen -t ed25519 -f "/etc/ssh/${host_key}" < /dev/null
	fi
}

install_ssh_server() {
	$sudo apt-get install -y openssh-server
	$sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak."$(date +%Y%m%d%H%M)"
	$sudo cp "${this_dir}"/sshd_config /etc/ssh/
}

{
	check_sudo
	install_ssh_server
	generate_keys
	#configure_firewall
}
