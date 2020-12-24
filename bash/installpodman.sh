#!/bin/bash

set -e

TMP=/etc/os-release
if [ ! -f $TMP ]; then
	echo "$TMP does not exist. Cannot install podman"
	exit 1
fi

. /etc/os-release

# Get _install
. ${SETUP_DIR}/bash/helperFuncs.sh

_install curl

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | sudo apt-key add -

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install podman

exit 0
