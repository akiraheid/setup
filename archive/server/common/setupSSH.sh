#!/bin/bash
set -e

echo "Installing SSH server"
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
PrintMotd no
Protocol 2
PubKeyAuthentication yes
UseDNS no
UsePAM yes
X11Forwarding no" > /etc/ssh/sshd_config

echo "Restarting SSH service"
service ssh restart

#echo "Installing fail2ban"
