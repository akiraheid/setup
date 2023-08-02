#!/usr/bin/env bash
# Install Jellyfin on the remote home server

set -ex

BASEDIR=$(dirname "$BASH_SOURCE")
server=home

ssh $server ./jellyfin/install.sh
rsync -rc $BASEDIR/../services/jellyfin/* $server:~/jellyfin/

ssh $server ./jellyfin/install.sh
