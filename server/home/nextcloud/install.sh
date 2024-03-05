#!/bin/bash
# Install nextcloud on the home server
set -e

scriptdir=`dirname $(readlink -f $0)`

appdir=/raid/apps/nextcloud
configdir=$appdir/config
customappdir=$appdir/custom_apps
datadir=$appdir/data
sqldbdir=$appdir/sqldb

echo "scriptdir   =$scriptdir"
echo "appdir      =$appdir"
echo "configdir   =$configdir"
echo "customappdir=$customappdir"
echo "datadir     =$datadir"
echo "sqldbdir    =$sqldbdir"

mkdir -pv "$configdir" "$customappdir" "$datadir" "$sqldbdir"

cp -v deployment.yaml start.sh "$appdir/"

anacrondir=~/anacron/hourly
if [ ! -d "$anacrondir" ]; then
	echo "ERROR: Install anacron first"
fi

cp -v anacron.sh "$anacrondir/startNextcloud"

echo "Installed nextcloud"
