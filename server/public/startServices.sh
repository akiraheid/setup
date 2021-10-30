#!/bin/bash
set -e

# Clean up old containers/images
podman container prune -f
podman image prune -f

(cd /root/polo && ./deploy.sh)
