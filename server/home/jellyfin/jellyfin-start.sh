#!/bin/bash
set -e

date -u

echo "Start pod"
DIR=$(dirname -- $0;)
cd $DIR

POD=jellyfin-pod
podman pod exists $POD || podman play kube jellyfin-pod.yaml
echo "Start pod... done"

echo "Remove old images"
podman image prune -f
echo "Remove old images... done"
