#!/bin/bash
set -e

DIR=$(dirname `readlink -f $0`)

echo "Install Jellyfin..."

name=jellyfin
set +e
if id $name >/dev/null 2>&1; then
	set -e
	echo "User $name already exists"
else
	set -e
	echo "User $name doesn't exist"
	echo "Create user $name"
	# Home directory is needed for podman files
	sudo addgroup $name
	sudo adduser --disabled-password --ingroup $name $name
	echo "Create user ${name}... done"
fi

echo "Create data dirs..."
selfSignedDir=/etc/ssl/self_signed
sudo mkdir -pv /raid
pushd /raid
sudo mkdir -pv adventures books movies music podcasts shows \
	sync/family/family-photos \
	$selfSignedDir
popd
echo "Create data dirs... done"

echo "Install start script..."
pushd "$DIR"
startScript="start.sh"
cronscript="cron.sh"
yaml="pod.yaml"
chmod 755 $startScript $cronscript
sudo cp $startScript $yaml /home/jellyfin/
sudo cp $cronscript /etc/cron.daily/jellyfin.sh
popd
echo "Install start script... done"

echo "Create self-signed SSL cert..."
domain=backend.media.heid.cc
pub=${domain}.crt
priv=${domain}.key
if [ ! -f $selfSignedDir/$priv ]; then
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out $pub -keyout $priv
	cp $pub $priv $selfSignedDir/
fi
echo "Transfer $pub to public servers!"
echo "Create self-signed SSL cert... done"

echo "Install Jellyfin... done"
