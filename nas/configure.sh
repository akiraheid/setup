#!/usr/bin/env bash
# Configure the NAS

set -ex

thisDir=$(dirname "$(readlink -f "$0")")
commonDir="${thisDir}"/../common
sudo=

. "${commonDir}"/logging.sh

check_sudo() {
	if ! [[ "$UID" ]]; then
		sudo=sudo
	fi
}

install_ssh() {
	bash "${commonDir}"/ssh/configure-server.sh
}

install_ufw() {
	info "Installing Uncomplicated Firewall (UFW)..."
	$sudo apt-get install -y --no-install-recommends ufw
}

lockdown_firewall() {
	$sudo ufw default deny
	$sudo ufw enable
}

open_reverse_tunnel() {
	info "Setting up reverse tunnel"
	ssh -N -R 2222:localhost:22 tunnel@heid.cc
}

setup_mDNS() {
	bash "${commonDir}"/setup_mDNS.sh
}

{
	$sudo apt-get update
	check_sudo
	install_ufw
	install_ssh
	#open_reverse_tunnel
	#setup_mDNS
	#lockdown_firewall
}
