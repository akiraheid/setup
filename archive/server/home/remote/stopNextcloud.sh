#!/usr/bin/env bash
# Stop Nextcloud instance

set -ex

server=home
ssh $server podman pod stop nextcloud
