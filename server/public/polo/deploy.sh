#!/bin/bash

set -e

mkdir -p ~/polo/ips
touch ~/polo/users.txt

podName=polo-deployment-pod-0
(podman pod exists $podName || false) && podman pod stop $podName && podman pod rm $podName
podman play kube deployment.yaml
