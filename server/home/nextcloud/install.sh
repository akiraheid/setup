#!/bin/bash
# Install nextcloud on the home server
set -e

scriptdir=`dirname $(readlink -f $0)`
cd "${scriptdir}"

appdir=/raid/apps/nextcloud
configdir=$appdir/config
customappdir=$appdir/custom_apps
datadir=$appdir/data
sqldbdir=$appdir/sqldb

echo "appdir      =$appdir"
echo "configdir   =$configdir"
echo "customappdir=$customappdir"
echo "datadir     =$datadir"
echo "sqldbdir    =$sqldbdir"

mkdir -pv "$configdir" "$customappdir" "$datadir" "$sqldbdir"

yaml=deployment.yaml
appyaml=${appdir}/${yaml}
if [ -f "${appyaml}" ]; then
	echo "ERROR: ${appyaml} already exists. Manually update ${appyaml}"
	echo "       Be sure to keep the password values!"
else
	cp -v "${yaml}" "${appyaml}"
fi

chmod -v 755 start.sh anacron.sh
cp -v start.sh "${appdir}/"

anacrondir=~/anacron/hourly
if [ ! -d "$anacrondir" ]; then
	echo "ERROR: Install anacron first"
	exit 1
fi

cp -v anacron.sh "${anacrondir}/startNextcloud"

echo "Installed nextcloud"
