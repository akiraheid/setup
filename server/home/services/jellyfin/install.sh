#!/bin/bash
set -e

date -u

echo "Install Jellyfin"

#echo "Create data dirs"
#sudo mkdir -pv /raid
#pushd /raid
#sudo mkdir -pv adventures books movies music podcasts shows \
#	sync/family/family-photos \
#	/etc/ssl/self_signed
#popd
#echo "Create data dirs... done"

echo "-Installing safe start cron..."
BASEDIR=$(dirname "$BASH_SOURCE")
sudo cp $BASEDIR/safeStart.sh /etc/cron.hourly/
echo "-Installing safe start cron... done"

echo "-Starting service..."
$BASEDIR/safeStart.sh
echo "-Starting service... done"

echo "Install Jellyfin... done"
