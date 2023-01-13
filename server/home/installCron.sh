#!/bin/bash
set -e

date -u

#echo "Create hourly cron"
#sudo rsync -c updateIP.sh /etc/cron.hourly/
#echo "Create hourly cron... done"

DIR=$(dirname -- $0;)

echo "Create daily cron"
pushd $DIR/jellyfin
sudo rsync -c jellyfin-pod.yaml jellyfin-start.sh /etc/cron.daily/
popd
echo "Create daily cron... done"

echo "Create weekly cron"
sudo rsync -c $DIR/updateSystem.sh /etc/cron.weekly/
echo "Create weekly cron... done"
