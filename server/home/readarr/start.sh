#!/bin/bash
set -e

date -u

DIR=$(dirname `readlink -f $0`)

# Use "readarr-pod" because podman will rename the pod if a container in the pod
# has the same name
podname=readarr-pod
if podman pod exists $podname ; then
	if [ `podman pod inspect --format "{{.State}}" $podname` == "Running" ] ; then
		echo "Pod $podname is already running"
		exit 0
	else
		podman pod rm -f $podname
	fi
fi

echo "Start pod..."
cd $DIR
podman play kube pod.yaml
echo "Start pod... done"
