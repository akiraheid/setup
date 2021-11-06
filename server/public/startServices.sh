#!/bin/bash
set -e

# Clean up old containers/images
podman container prune -f
podman image prune -f

# Run as polo user
(cd /home/polo/polo && runuser -u polo -g polo bash ./deploy.sh)
