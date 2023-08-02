#!/bin/bash
# Create back up files of jellyfin data.
set -e

backup=/raid/backup/jellyfin
mkdir -p $backup
cd $backup

date=`date +%Y%m%d-%H%M`

# Container volumes
config=jellyfin-config

echo "Backing up $config..."
podman volume export $config | gzip > $date-$config.tar.gz
echo "Backing up $config...done"
