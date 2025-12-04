#!/bin/bash
set -e

USERNAME=jellyfin
(cd /home/jellyfin && runuser -u jellyfin -g jellyfin bash ./deploy.sh)
