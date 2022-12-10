#!/usr/bin/env bash
# Run commands on server to backup Nextcloud instance

set -ex

BASEDIR=$(dirname "$BASH_SOURCE")
server=home

rsync -r $BASEDIR/../services/nextcloud/* $server:~/nextcloud/

ssh $server ./nextcloud/backup.sh
