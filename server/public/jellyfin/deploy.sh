#!/bin/bash

set -e

podName=jellyfin-deployment-pod-0
podman pod rm -if $podName
podman play kube deployment.yaml
