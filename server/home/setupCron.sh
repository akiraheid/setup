#!/bin/bash

set -e

echo "Existing cron jobs"
crontab -l

echo "Clear existing cron jobs"
crontab -r
echo "Clear existing cron jobs - Done"

echo "Install root cron jobs"
cp cron.txt /root/cron.txt
cp updateSystem.sh /root/updateSystem.sh
cp startServices.sh.sh /root/startServices.sh.sh
crontab /root/cron.txt
echo "Install root cron jobs - Done"
