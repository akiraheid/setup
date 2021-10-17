#!/bin/bash

echo "Clear existing cron jobs"
crontab -r
echo "Clear existing cron jobs - Done"

set -e
echo "Install root cron jobs"

cp updateSystem.sh /root/updateSystem.sh
echo "\nreboot now" >> /root/updateSystem.sh

echo "# m     h  dom  mon  dow  command
* 3 * * 0 bash /root/updateSystem.sh" > /root/cron.txt

crontab /root/cron.txt
echo "Install root cron jobs - Done"
