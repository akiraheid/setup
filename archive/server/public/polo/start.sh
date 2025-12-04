#!/bin/bash
set -e

# Run as polo user
(cd /home/polo && runuser -u polo -g polo bash ./deploy.sh)
