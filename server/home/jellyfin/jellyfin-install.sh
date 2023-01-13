#!/bin/bash
set -e

date -u

echo "Install Jellyfin"

#echo "Create data dirs"
#sudo mkdir -pv /raid
#pushd /raid
#sudo mkdir -pv adventures books movies music podcasts shows \
#	sync/family/family-photos \
#	/etc/ssl/self_signed
#popd
#echo "Create data dirs... done"

DIR=$(dirname -- $0;)
$DIR/jellyfin-start.sh

echo "Install Jellyfin... done"
