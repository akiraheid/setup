#!/bin/bash
# Create back up files of vikunja data.
set -e

date=`date +%Y%m%d-%H%M`

#backup=/raid/backup/vikunja
#cd $backup

# Container volumes
#config=vikunja-config
#customapps=vikunja-custom_apps
#db=vikunja-db
#
#echo "Backing up $config..."
#podman volume export $config | gzip > $date-$config.tar.gz
#echo "Backing up $config...done"
#
#echo "Backing up $customapps..."
#podman volume export $customapps | gzip > $date-$customapps.tar.gz
#echo "Backing up $customapps...done"
#
#echo "Backing up $db..."
#podman volume export $db | gzip > $date-$db.tar.gz
#echo "Backing up $db...done"
#
## Actual files
#storage=/raid/vikunja/storage
#echo "Backing up $storage..."
#pushd $storage
#tar -czf $backup/$date-vikunja-storage.tar.gz *
#popd
#echo "Backing up $storage...done"
