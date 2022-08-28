#!/bin/bash

echo "Clear existing cron jobs"
crontab -r
echo "Clear existing cron jobs - done"

set -e

echo "cron - Install daily update"
updateFile=/etc/cron.daily/updateSystem
cp updateSystem.sh $updateFile
chmod 755 $updateFile
echo "cron - Install daily update - done"

echo "cron - Install reboot cron"
mkdir -p /etc/cron.reboot
rebootFile=/etc/runRebootCron.sh
echo "find /etc/cron.reboot -type f -exec bash {} \;" > $rebootFile
chmod 755 $rebootFile

rootCronFile=/root/cron.txt
echo "# m     h  dom  mon  dow  command
0 3 * * 0 reboot now
@reboot bash $rebootFile" > $rootCronFile

crontab $rootCronFile
rm $rootCronFile
echo "cron - Install reboot cron - done"
