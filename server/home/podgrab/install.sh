#!/bin/bash
set -e

anacrondir=~/anacron/hourly
if [ ! -d "$anacrondir" ]; then
	echo "ERROR: Install anacron for $USER first"
	exit 1
fi

DIR=$(dirname `readlink -f $0`)
cd "$DIR"

name=podgrab

echo "Install $name..."

echo "Create app dirs..."
appDir=/raid/apps/$name
configDir=${appDir}/config
podcastDir=${appDir}/podcasts
sudo mkdir -pv "$appDir"
sudo chown $USER:$USER "$appDir"
mkdir -pv "$configDir" "$podcastDir"
echo "Create app dirs... done"

echo "Install start script..."
startScript="start.sh"
cronscript="cron.sh"
chmod -v 755 "$startScript" "$cronscript"
cp -v "$startScript" "${appDir}/"
cp -v "$cronscript" "${anacrondir}/startPodgrab"
echo "Install start script... done"

yaml="pod.yaml"
appyaml=${appDir}/${yaml}
if [ -f "$appyaml" ]; then
	echo "$appyaml already exists. Leaving existing file alone."
	# Make sure existing file is protected because it has a pasword
	chmod -v 700 "$appyaml"
else
	cp -v "$yaml" "$appyaml"
fi

echo "Install $name... done"
