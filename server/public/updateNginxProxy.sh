#!/bin/bash
set -e

function updateFile() {
	if [ $# -ne 2 ]; then
		echo "ERROR: Expected file and IP"
		exit 1
	fi

	key="# Managed by NGINX proxy updater"
	ipRegex="(([0-9]){1,3}\.){3}[0-9]{1,3}"
	oldIp=`grep -oE -m 1 "${ipRegex}.*${key}" "$1" | grep -oE "${ipRegex}"`

	sed -i "s/$oldIp\(.*${key}\)/$2\1/" "$1"

	nginx -t
}

# Read IP for media.heid.cc from generated file
ipFile=/home/polo/ips/akira.txt
newIP=`cat $ipFile | cut -d: -f2`
updateFile /etc/nginx/sites-enabled/media.heid.cc $newIP

systemctl restart nginx
