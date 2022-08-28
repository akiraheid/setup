#!/bin/bash
set -e

THIS_DIR=`dirname ${BASH_SOURCE[0]}`

echo "Setup Jellyfin"

# Install dependencies
apt-get install -y podman

# Setup user
bash $THIS_DIR/../../common/setupDummyUser.sh jellyfin

DEPLOY_DIR=/home/jellyfin
cp -r $THIS_DIR/* $DEPLOY_DIR/
chown -R jellyfin:jellyfin $DEPLOY_DIR
chmod 700 $DEPLOY_DIR

cp $THIS_DIR/start.sh /etc/cron.reboot/startJellyfin.sh

echo "Setup Jellyfin - done"
