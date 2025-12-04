#!/bin/bash
# Start the Jellyfin pod if not already started.

BASEDIR=$(dirname "$BASH_SOURCE")
podname=jellyfin-pod
(podman pod exists $podname && podman pod start ${podname}) || podman play kube $BASEDIR/pod.yaml
