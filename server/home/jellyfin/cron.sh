#!/bin/sh
set -e
cd /home/jellyfin
runuser jellyfin ./start.sh >> log.txt 2>&1
