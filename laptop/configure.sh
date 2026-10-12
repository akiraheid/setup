#!/usr/bin/env bash
# Configure the laptop
set -e

thisDir=$(dirname "$(readlink -f "$0")")

source "${thisDir}"/../common/logging.sh

configure_ssh() {
	cp "${thisDir}/.ssh" "${HOME}/"
}

setup_mDNS() {
	bash "${thisDir}"/../common/setup_mDNS.sh
}

# Protect ports
setup_ufw() {
	sudo apt-get install -y ufw
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	sudo ufw enable
	sudo ufw status
}

update_system() {
	bash "${thisDir}"/../common/update_system.sh
}

{
	setup_ufw
	setup_mDNS
}
