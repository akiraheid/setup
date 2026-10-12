#!/usr/bin/env bash
# Set up mDNS
set -e

this_dir=$(dirname "$(readlink -f "$0")")

# mDNS resolves hosts via [hostname].local without a DNS server on the local
# network.
setup_mDNS() {
	sudo apt install avahi-daemon avahi-utils libnss-mdns

	sudo cp -v "${this_dir}"/avahi-daemon.conf /etc/avahi/avahi-daemon.conf

	echo "Applying the configuration..."
	sudo systemctl enable avahi-daemon
	sudo systemctl start avahi-daemon
	echo "mDNS resolution configured successfully"

	echo "Opening the port in the firewall..."
	sudo ufw allow 5353/udp
	echo "Opening the port in the firewall... done"
}

{
	setup_mDNS
}
