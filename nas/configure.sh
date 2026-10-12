#!/usr/bin/env bash
# Configure the NAS

thisDir=$(dirname "$(readlink -f "$0")")

install_ssh() {
	sudo apt-get install -y openssh-server

	echo "Configure SSH server"
	sudo cp "./${thisDir}/../ssh/sshd_config" /etc/ssh/sshd_config
}

open_reverse_tunnel() {
	ssh -N -R 2222:localhost:22 tunnel@heid.cc
}

setup_mDNS() {
	bash "${thisDir}"/../common/setup_mDNS.sh
}

{
	#install_ssh
	#open_reverse_tunnel
	setup_mDNS
}
