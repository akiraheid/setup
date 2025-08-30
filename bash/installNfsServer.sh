#!/usr/bin/env bash
# Install the NFS server components and security.
set -e

setup_env() {
	# Use sudo if we are not already root
	SUDO=sudo
	if [ "$(id -u)" -eq 0 ]; then
		SUDO=
	fi

	THIS_DIR=$(dirname "$(readlink -f "$0")")
}

install_wireguard() {
	"${THIS_DIR}/installWireguard.sh"
}

install_nfs_server() {
	$SUDO apt-get update
	$SUDO apt-get install -y nfs-kernel-server

	# Protect generated files
	umask 077
	$SUDO echo >/etc/wireguard/wg-nfs.conf << EOF
[Interface]
Address = 10.222.0.1/24
PrivateKey = $(cat /etc/wireguard/privatekey)
ListenPort = 51820
EOF

	$SUDO systemctl enable wg-quick@wg-nfs.service
}

{
	setup_env
	install_wireguard
	install_nfs_server
}
