#!/bin/bash
# Script to run on first start of a server
set -e

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove

# Verify configuration files
if [ ! -d conf ]; then
	echo "Error: Copy either home/ or public/ here as conf/"
	exit 1
fi

# ========== USER CREATION ==========
echo "Creating dummy user"
# Creates user with a random password
PASS=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 30)
PASS=$(perl -e 'print crypt($ARGV[0], "password")' $PASS)
groupadd dummy
useradd --no-create-home -g dummy -p $PASS dummy
echo "Creating dummy user - Done"


# ========== SSH ==========
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
HostKey /etc/ssh/ssh_host_ecdsa_key
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

echo "Restarting SSH service"
service ssh restart

#echo "Installing fail2ban"


# ========== FIREWALL ==========
echo "Setting up firewall"
#fwredirect() {
#	FROM=$1
#	TO=$2
#    echo "  Redirecting ${FROM} => ${TO}..."
#	iptables -A INPUT -i $INTERFACE -p tcp --dport $FROM -j ACCEPT
#	iptables -A INPUT -i $INTERFACE -p udp --dport $FROM -j ACCEPT
#	iptables -A INPUT -i $INTERFACE -p tcp --dport $TO -j ACCEPT
#	iptables -A INPUT -i $INTERFACE -p udp --dport $TO -j ACCEPT
#	iptables -A PREROUTING -t nat -i $INTERFACE -p tcp --dport $FROM -m state --state NEW -j REDIRECT --to-port $TO
#	iptables -A PREROUTING -t nat -i $INTERFACE -p udp --dport $FROM -m state --state NEW -j REDIRECT --to-port $TO
#}

apt-get install -y ufw
echo "y" | ufw enable
ufw allow 22
ufw allow out to any port 53
ufw allow out to any port 80
ufw allow out to any port 443
ufw allow from 127.0.0.1 to 127.0.0.1
ufw default deny outgoing
ufw reload
echo "Setting up firewall - Done"

# ========== UNATTENDED UPGRADES ==========
echo "Installing unattended-upgrades"
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
echo "Installing unattended-upgrades - Done"

# ========= CRON ==========
echo "Clear existing cron jobs"
crontab -r
echo "Clear existing cron jobs - Done"

echo "Install root cron jobs"
echo "# m     h  dom  mon  dow  command
@reboot  runuser -u dummy /root/startServices.sh" > /root/cron.txt

crontab /root/cron.txt
cp conf/startServices.sh conf/services.yaml /root/

echo "Install root cron jobs - Done"

# ========== SERVICES ==========
bash conf/setupServices.sh

reboot now
