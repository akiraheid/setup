#!/usr/bin/env bash
# Start Jellyfin if a pod already exists, otherwise start from scratch.

set -ex

BASEDIR=$(dirname "$BASH_SOURCE")
server=home

rsync -rc $BASEDIR/../services/jellyfin/* $server:~/jellyfin/

ssh $server ./jellyfin/safeStart.sh
