#!/bin/bash
set -e

anacrondir=~/anacron/hourly
if [ ! -d "$anacrondir" ]; then
	echo "ERROR: Install anacron for $USER first"
	exit 1
fi

DIR=$(dirname `readlink -f $0`)
cd "$DIR"

echo "Install Grocy..."

name=grocy

echo "Create app dirs..."

appDir=/raid/apps/$name
sudo mkdir -pv "$appDir"
sudo chown -v $USER:$USER $appDir
echo "Create app dirs... done"

echo "Create files..."
# grocy-backend runs as uid:gid 82:82 and mounted volumes are owned by
# root:nobody in the container, so have podman change ownership of the directory
# to match the uid:gid mapping in the container
dbPath=$appDir/grocy.db
if [ -f "$dbPath" ]; then
	echo "$dbPath already exists. Leaving existing file alone."
else
	touch "$dbPath"
fi

configPath=$appDir/config.php
if [ -f "$configPath" ]; then
	echo "$configPath already exists. Leaving existing file alone."
else
	cp -v config.php "$configPath"
fi

podman unshare chown -v 82:82 "$configPath" "$dbPath"

# nginx file doesn't need to change ownership
cp -rv nginx $appDir/
echo "Create files... done"

echo "Install start script..."
startScript="start.sh"
cronscript="cron.sh"
chmod -v 755 "$startScript" "$cronscript"
cp -rv "$startScript" nginx "${appDir}/"

yaml="pod.yaml"
appyaml=${appDir}/${yaml}
if [ -f "$appyaml" ]; then
	echo "$appyaml already exists. Leaving existing file alone."
else
	cp -v "$yaml" "$appyaml"
fi

cp -v "$cronscript" "${anacrondir}/startGrocy"
echo "Install start script... done"

echo "Install Grocy... done"
