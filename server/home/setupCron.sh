#!/bin/bash

set -e

echo "Existing cron jobs"
crontab -l

echo "Clear existing cron jobs"
crontab -r
echo "Clear existing cron jobs - Done"

echo "Install DDNS updater"
IS_DEFAULT=`grep "fill me" updateIP.sh`
if [ "$IS_DEFAULT" ]; then
	echo "Get a polo token and update updateIP.sh"
	exit 1
fi
cp updateIP.sh /root/updateIP.sh
echo "Install DDNS updater - Done"

echo "Install root cron jobs"
cp cron.txt /root/cron.txt
cp updateSystem.sh /root/updateSystem.sh
cp startServices.sh /root/startServices.sh
crontab /root/cron.txt
echo "Install root cron jobs - Done"
