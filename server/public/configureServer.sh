#!/bin/bash
# Configure the host with the given IP as a public server
set -ex

if [ -z "$1" ]; then
	echo "ERROR: Expected IP/host"
	exit 1
fi

IP=$1
SSH_CMD="ssh ubuntu@$IP"

#ssh-keygen -f ~/.ssh/known_hosts -R $IP

HOME_DIR=`$SSH_CMD echo \\\$HOME`
SETUP_DIR=$HOME_DIR/setup

$SSH_CMD mkdir -p $SETUP_DIR
rsync -rc ../common ../public ubuntu@$IP:$SETUP_DIR/
$SSH_CMD cd $SETUP_DIR/public\; sudo bash init.sh

echo "Rebooting server"
$SSH_CMD sudo shutdown -r now
