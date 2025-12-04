#!/bin/bash
# Script to run on first start of a server
set -e

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove


# ========== SSH ==========
if [ -z "$(which ssh)" ]; then
	echo "Installing SSH server..."
	apt-get install -y openssh-server

	mkdir -p /etc/ssh

	if [ ! -f /etc/ssh/ssh_host_ed25519_key.pub ]; then
		echo "Generating ED25519 key"
		ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key < /dev/null
	fi

	if [ ! -f /etc/ssh/ssh_host_rsa_key.pub ]; then
		echo "Generating RSA key"
		ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key < /dev/null
	fi

	echo "Generating sshd_config"
	echo "AllowAgentForwarding no
	AllowTcpForwarding no
	ChallengeResponseAuthentication no
	HostKey /etc/ssh/ssh_host_ed25519_key
	HostKey /etc/ssh/ssh_host_rsa_key
	LoginGraceTime 5
	LogLevel VERBOSE
	PasswordAuthentication no
	PermitEmptyPasswords no
	PermitRootLogin no
	Port 22
	PrintMotd no
	Protocol 2
	PubKeyAuthentication yes
	RSAAuthentication yes
	ServerKeyBits 4096
	UseDNS no
	UsePAM yes
	X11Forwarding no" > /etc/ssh/sshd_config
	echo "Installing SSH server... done"

	echo "Restarting SSH service..."
	service ssh restart
	echo "Restarting SSH service... done"
fi


# ========== FIREWALL ==========
echo "Setting up firewall..."

apt-get install -y ufw
echo "y" | ufw enable
ufw allow 22
ufw allow out to any port 53
ufw allow out to any port 80
ufw allow out to any port 443
ufw allow from 127.0.0.1 to 127.0.0.1
ufw default deny outgoing
ufw reload
echo "Setting up firewall... done"

# ========== UNATTENDED UPGRADES ==========
echo "Installing unattended-upgrades..."
apt-get install -y unattended-upgrades update-notifier-common
echo " Unattended-Upgrade::Allowed-Origins {
\"\${distro_id}:\${distro_codename}\";
\"\${distro_id}:\${distro_codename}-security\";
\"${distro_id}ESMApps:${distro_codename}-apps-security\";
\"${distro_id}ESM:${distro_codename}-infra-security\";
};

Unattended-Upgrade::Package-Blacklist {
};

Unattended-Upgrade::DevRelease \"auto\";
Unattended-Upgrade::Remove-Unused-Kernel-Packages \"true\";
Unattended-Upgrade::Remove-New-Unused-Dependencies \"true\";
Unattended-Upgrade::Remove-Unused-Dependencies \"false\";
Unattended-Upgrade::Automatic-Reboot \"true\";
Unattended-Upgrade::Automatic-Reboot-WithUsers \"true\";
Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";" > /etc/apt/apt.conf.d/50unattended-upgrades
echo "Installing unattended-upgrades... done"


# ========== PODMAN ==========
apt-get install -y podman

./setupUsers.sh

reboot now
