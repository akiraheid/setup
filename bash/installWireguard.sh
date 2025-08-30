#!/bin/bash
set -eo pipefail

# Use sudo if we are not already root
SUDO=sudo
if [ "$(id -u)" -eq 0 ]; then
	SUDO=
fi

$SUDO apt-get update
$SUDO apt-get install -y wireguard

# Protect the key
umask 077
$SUDO cd /etc/wireguard

# Generate the key pair
$SUDO wg genkey | tee privatekey | wg pubkey > publickey
chmod 644 publickey

cat <<EOF >>wg0.conf
[Interface]
Address = 10.222.0.3/24
PrivateKey = $(cat privatekey)
ListenPort = 51820
EOF
