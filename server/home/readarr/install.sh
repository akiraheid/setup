#!/bin/bash
set -e

DIR=$(dirname `readlink -f $0`)

echo "Install readarr..."

name=readarr

echo "Create data dirs..."
dataDir=/raid/apps/readarr
sudo mkdir -pv $dataDir/{config,data}
sudo chown -R $USER:$USER $dataDir
echo "Create data dirs... done"

echo "Install readarr... done"
