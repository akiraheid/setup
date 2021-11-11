#!/bin/bash
set -e

echo "Setting up firewall"
fwredirect() {
	FROM=$1
	TO=$2
    echo "  Redirecting ${FROM} => ${TO}..."
	iptables -A INPUT -i $INTERFACE -p tcp --dport $FROM -j ACCEPT
	iptables -A INPUT -i $INTERFACE -p udp --dport $FROM -j ACCEPT
	iptables -A INPUT -i $INTERFACE -p tcp --dport $TO -j ACCEPT
	iptables -A INPUT -i $INTERFACE -p udp --dport $TO -j ACCEPT
	iptables -A PREROUTING -t nat -i $INTERFACE -p tcp --dport $FROM -m state --state NEW -j REDIRECT --to-port $TO
	iptables -A PREROUTING -t nat -i $INTERFACE -p udp --dport $FROM -m state --state NEW -j REDIRECT --to-port $TO
}

apt-get install -y ufw
echo "y" | ufw enable
# 4269 is remapped SSH
ufw allow 4269
ufw allow 80
ufw allow 443
ufw allow out to any port 53
ufw allow out to any port 80
ufw allow out to any port 443
ufw allow from 127.0.0.1 to 127.0.0.1
ufw default deny outgoing
ufw reload
echo "Setting up firewall - Done"
