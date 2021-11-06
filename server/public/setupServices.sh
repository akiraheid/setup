#!/bin/bash
set -e

echo "Setup services"
cp startServices.sh /etc/cron.reboot/

if id polo &>/dev/null; then
	echo "polo user already exists"
else
	adduser polo
fi

cp -r polo /home/polo/
chown -R polo:polo /home/polo/polo
chmod 700 /home/polo/polo
echo "Setup services - done"
