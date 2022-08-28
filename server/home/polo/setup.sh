#!/bin/bash

set -e

THIS_DIR=`dirname ${BASH_SOURCE[0]}`

echo "Setup polo client"

CRON_FILE=/etc/cron.hourly/updatePoloIP.sh
echo "wget --header 'Content-Type: application/json' --post-data '{\"token\": \"\"}' https://ddns.heid.cc" > $CRON_FILE
chmod 700 $CRON_FILE
echo "Created $CRON_FILE please edit it with the user token."

echo "Setup polo client - done"
