#!/bin/bash
# Create back up files of nextcloud data.
set -e

backup=/raid/backup/nextcloud
cd $backup

date=`date +%Y%m%d-%H%M`

# Container volumes
config=nextcloud-config
customapps=nextcloud-custom_apps
db=nextcloud-db

echo "Backing up $config..."
podman volume export $config | gzip > $date-$config.tar.gz
echo "Backing up $config...done"

echo "Backing up $customapps..."
podman volume export $customapps | gzip > $date-$customapps.tar.gz
echo "Backing up $customapps...done"

echo "Backing up $db..."
podman volume export $db | gzip > $date-$db.tar.gz
echo "Backing up $db...done"

# Actual files
storage=/raid/nextcloud/storage
echo "Backing up $storage..."
pushd $storage
tar -czf $backup/$date-nextcloud-storage.tar.gz *
popd
echo "Backing up $storage...done"
