#!/bin/bash
set -e

DIR=$(dirname `readlink -f $0`)

echo "Install Podgrab..."

name=podgrab

echo "Create data dirs..."
dataDir=/raid/apps/podgrab
sudo mkdir -pv $dataDir
sudo chown $USER:$USER $dataDir
echo "Create data dirs... done"

echo "Install cron job..."
bash $DIR/../installUserCron.sh
toPath=$HOME/cron/daily/podgrab-link.sh
ln -v "$DIR/cron.sh" $toPath
chmod 700 $toPath
echo "Install cron job... done"

echo "Install Podgrab... done"
