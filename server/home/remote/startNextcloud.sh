#!/usr/bin/env bash
# Start Nextcloud instance

set -ex

BASEDIR=$(dirname "$BASH_SOURCE")
server=home

rsync -r $BASEDIR/../services/nextcloud/* $server:~/nextcloud/

ssh $server ./nextcloud/start.sh
