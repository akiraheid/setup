#!/bin/sh
set -e

cd /raid/apps/jellyfin
./start.sh | tee ./log.txt
