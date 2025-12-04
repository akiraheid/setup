#!/bin/bash
set -e

THIS_DIR=`dirname ${BASH_SOURCE[0]}`

echo "Setup polo"

# Install dependencies
apt-get install -y podman

# Setup user
bash $THIS_DIR/../../common/setupDummyUser.sh polo

POLO_HOME=/home/polo
cp -r $THIS_DIR/* $POLO_HOME/
chown -R polo:polo $POLO_HOME
chmod 700 $POLO_HOME

cp $THIS_DIR/start.sh /etc/cron.reboot/startPolo.sh

echo "Setup polo - done"
