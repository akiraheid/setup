#!/bin/bash
set -e

bash ../common/setupFirewall.sh

echo "Setting up firewall"

ufw allow out to any port 8080 # Media server
ufw reload

echo "Setting up firewall - Done"
