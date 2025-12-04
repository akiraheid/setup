#!/bin/bash
# Configuring based on https://d.sb/2020/12/nfs-howto
set -eo pipefail

# Use sudo if we are not already root
SUDO=sudo
if [ "$(id -u)" -eq 0 ]; then
	SUDO=
fi

$SUDO apt-get install -y wireguard

wg_dir=/etc/wireguard
$SUDO cd "$wg_dir"

# Protect the key
umask 077

# Generate the key pair
$SUDO wg genkey | tee privatekey | wg pubkey > publickey
chmod 644 publickey

wgconf=wg0.conf

echo "[Interface]" > "$wgconf"
echo "Address = 10.222.0.1/24" >> "$wgconf"
echo "PrivateKey = $(cat privatekey)" >> "$wgconf"
echo "ListenPort = 51820" >> "$wgconf"

echo "Each peer must still be added to the ${wg_dir}/${wgconf} file under a"
echo "[Peer] section. For example:"
echo "  [Peer]"
echo "  PublicKey = abcdefghijklmnopqrstuvwxyz="
echo "  Endpoint = hostname.local:51820"
echo "  AllowedIPs = 10.222.0.1/32"
