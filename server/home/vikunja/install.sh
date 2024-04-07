#!/bin/bash
# Install vikunja on the home server
set -e

scriptdir=`dirname $(readlink -f $0)`
cd "${scriptdir}"

appdir=/raid/apps/vikunja
config=$appdir/config.yaml
filesdir=$appdir/files
dbdir=$appdir/db

echo "appdir  =$appdir"
echo "config  =$config"
echo "filesdir=$filesdir"
echo "dbdir   =$dbdir"

mkdir -pv "$filesdir" "$dbdir"

echo "App runs as UID 1000."
podman unshare chmod -Rv 770 "$appdir"
podman unshare chown -v 1000:$USER "$filesdir" "$dbdir"

yaml=deployment.yaml
appyaml=${appdir}/${yaml}
cp -v "${yaml}" "${appyaml}"

chmod -v 755 start.sh anacron.sh
cp -v start.sh "${appdir}/"

anacrondir=~/anacron/hourly
if [ ! -d "$anacrondir" ]; then
	echo "ERROR: Install anacron first"
	exit 1
fi

cp -v anacron.sh "${anacrondir}/startVikunja"

echo "Installed vikunja"
