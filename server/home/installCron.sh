#!/bin/bash
set -e

date -u

#echo "Create hourly cron"
#sudo rsync -c updateIP.sh /etc/cron.hourly/
#echo "Create hourly cron... done"

DIR=$(dirname -- $0;)

echo "Create system weekly cron"
sudo rsync -c $DIR/updateSystem.sh /etc/cron.weekly/
echo "Create system weekly cron... done"

echo "Create $USER cron folders"
mkdir -pv $HOME/cron/{daily,hourly,monthly,weekly}
echo "Create $USER cron folders... done"

echo "Create $USER daily cron"
mkdir -pv ~/.anacron/{etc,spool}
ln -v anacrontab $HOME/.anacron/etc/anacrontab
crontab < cron.jobs
echo "Create $USER daily cron... done"
