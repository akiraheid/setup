#!/bin/bash

echo "Clear existing cron jobs"
crontab -r
echo "Clear existing cron jobs - Done"

set -e
echo "Install root cron jobs"

cp updateSystem.sh /etc/cron.daily/updateSystem.sh

mkdir -p /etc/cron.reboot
rebootFile=/etc/runRebootCron.sh
echo "find /etc/cron.reboot -type f -exec bash {} \;" > $rebootFile
chmod 755 $rebootFile

rootCronFile=/root/cron.txt
echo "# m     h  dom  mon  dow  command
* 3 * * 0 reboot now
@reboot bash $rebootFile" > $rootCronFile

crontab $rootCronFile
rm $rootCronFile
echo "Install root cron jobs - Done"
