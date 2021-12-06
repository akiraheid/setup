#!/bin/bash

set -e

podName=jellyfin-deployment-pod-0
(podman pod exists $podName || false) && podman pod stop $podName && podman pod rm $podName
podman play kube deployment.yaml
