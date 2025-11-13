#!/usr/bin/env bash
# Configure the NAS.

info() {
    echo '[INFO] ' "$@"
}
warn() {
    echo '[WARN] ' "$@" >&2
}
fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# Install bash settings
setup_bash() {
	info "Installing bash settings"
	date=$(date +%Y%m%d-%H%M%S)
	cp --suffix="${date}" ./bash/bashrc ~/.bashrc
	cp --suffix="${date}" ./bash/bash_aliases ~/.bash_aliases
	cp --suffix="${date}" ./bash/bash_functions ~/.bash_functions
	cp --suffix="${date}" ./bash/bash_profile ~/.bash_profile
	cp --suffix="${date}" ./bash/profile ~/.profile
}

setup_env() {
    # Use sudo if we are not already root
    SUDO=sudo
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=
    fi
}

# Avahi is used for mDNS to resolve hosts via [hostname].local without a DNS
# DNS server on the local network.
setup_mDNS() {
	$SUDO apt-get install -y avahi-daemon libnss-mdns
}

setup_vim() {
	info "Installing vim"
	$SUDO apt-get install -y vim
	date=$(date +%Y%m%d-%H%M%S)
	cp --suffix="${date}" ./vim/vimrc ~/.vimrc
}

setup_wireguard() {
	# Configuring based on https://d.sb/2020/12/nfs-howto
	info "Installing wireguard"
	$SUDO apt-get install -y wireguard

	local wg_dir
	local prikey
	local pubkey
	wg_dir=/etc/wireguard
	prikey=${wg_dir}/wg-privatekey
	pubkey=${wg_dir}/wg-publickey
	mkdir -p "${wg_dir}"

	wg genkey | $SUDO tee "${prikey}" | wg pubkey | $SUDO tee "${pubkey}"

	# Each peer must still be added to the wg0.conf file under a [Peer] section
	cat << EOF > "${wg_dir}/wg0.conf"
[Interface]
Address = 10.222.0.1/24
PrivateKey = $($SUDO cat ${prikey})
ListenPort = 51820
EOF
}

{
	setup_env
	setup_bash
	setup_mDNS
	setup_vim
}
