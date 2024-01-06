#!/bin/bash
set -e

DIR=$(dirname `readlink -f $0`)

echo "Install Grocy..."

name=grocy

echo "Create app dirs..."
appDir=/raid/apps/$name
configPath=$appDir/config.php
dbPath=$appDir/grocy.db

mkdir -pv "$appDir"
sudo chown -v $USER:$USER $appDir

# grocy-backend runs as uid:gid 82:82 and mounted volumes are owned by
# root:nobody in the container, so have podman change ownership of the directory
# to match the uid:gid mapping in the container
if [ -f "$dbPath" ]; then
	echo "$dbPath already exists"
else
	touch "$dbPath"
fi
cp -v $DIR/config.php "$configPath"
podman unshare chown 82:82 "$configPath" "$dbPath"

# nginx file doesn't need to change ownership
cp -rv $DIR/nginx $appDir/
echo "Create app dirs... done"

echo "Install Grocy... done"
