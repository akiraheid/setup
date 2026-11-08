#!/usr/bin/env bash
# Configure the laptop
set -e

this_dir=$(dirname "$(readlink -f "$0")")
common_dir=${this_dir}/../common
sudo=

. "${common_dir}"/check_sudo.sh
. "${common_dir}"/logging.sh

configure_ssh() {
	cp "${this_dir}/.ssh" "${HOME}/"
}

lockdown_uwf() {
	$sudo ufw enable
	$sudo ufw status
}

setup_mDNS() {
	bash "${common_dir}"/setup_mDNS.sh
}

# Protect ports
setup_ufw() {
	$sudo apt-get install -y ufw
	$sudo ufw default deny incoming
	$sudo ufw default allow outgoing
}

setup_vim() {
	bash "${common_dir}"/setup_vim.sh
}

setup_wireguard() {
	bash "${common_dir}"/setup_wireguard.sh
}

update_system() {
	bash "${common_dir}"/update_system.sh
}

{
	check_sudo
	#$sudo apt-get update
	setup_ufw
	setup_vim
	#setup_mDNS
	#lockdown_ufw
}
