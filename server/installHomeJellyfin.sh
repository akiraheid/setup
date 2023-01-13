#!/bin/bash
# Script to be called remotely to install the home Jellyfin server
set -e

if [ ! -d home ]; then
	echo "ERROR: Expected to be in server setup directory."
	exit 1
fi

echo "Updating home Jellyfin servers"

SERVER=home-jellyfin

echo "Copying home server configuration"
rsync -rc home/* $SERVER:~/setup/
echo "Copying home server configuration... done"

DIR="~/setup"

echo "Installing Jellyfin"
ssh -t $SERVER "$DIR/jellyfin/jellyfin-install.sh"
echo "Installing Jellyfin... done"

echo "Installing cron"
ssh -t $SERVER "$DIR/installCron.sh"
echo "Installing cron... done"

echo "Updating home Jellyfin servers... done"
