#!/bin/bash
set -e

DIR=$(dirname `readlink -f $0`)

echo "Install Jellyfin..."

name=jellyfin

echo "Create app dirs..."
appdir="/raid/apps/$name"
sudo mkdir -pv "$appdir"

echo "Change $appdir permissions to allow log writing"
sudo chown -v $USER:$USER "$appdir"

selfSignedDir=/etc/ssl/self_signed
sudo mkdir -pv /raid
pushd /raid
sudo mkdir -pv adventures books movies music podcasts shows \
	sync/family/family-photos \
	"$selfSignedDir"
popd
echo "Create app dirs... done"

echo "Install start script..."
pushd "$DIR"
startScript="start.sh"
cronscript="cron.sh"
yaml="pod.yaml"
chmod -v 755 $startScript $cronscript
cp -rv $startScript $yaml nginx "${appdir}/"

anacrondir=~/anacron/hourly
if [ ! -d "$anacrondir" ]; then
	echo "ERROR: Install anacron first"
	exit 1
fi

cp -v $cronscript "${anacrondir}/startJellyfin"
popd
echo "Install start script... done"

echo "Create self-signed SSL cert..."
domain=backend.media.heid.cc
pub=${domain}.crt
priv=${domain}.key
if [ -f $selfSignedDir/$priv ]; then
	echo "$selfSignedDir/$priv already exists"
	echo "Be sure $pub is on the public server if not done already"
else
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out $pub -keyout $priv
	cp -v $pub $priv $selfSignedDir/
	echo "Transfer $pub to public servers!"
fi
echo "Create self-signed SSL cert... done"

echo "Install Jellyfin... done"
