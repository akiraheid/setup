#!/bin/bash
#
# Reset firewall defaults settings (allow all traffic).

echo "Resetting firewall to default state of accepting everything..."
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -F
iptables -X

echo "Done!"
