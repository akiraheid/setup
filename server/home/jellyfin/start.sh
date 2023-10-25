#!/bin/bash
set -e

date -u

DIR=$(dirname `readlink -f $0`)

podname=jellyfin
echo "Check for existing pod..."
set +e
exists="`podman pod exists $podname && echo 1`"
set -e

if [ -n "$exists" ]; then
	echo "Pod exists"
	echo "Check if running"
	podstatus=`podman pod ps | grep $podname | sed 's/\s\+/ /g' | cut -d ' ' -f 3`
	if [ "$podstatus" != "Running" ]; then
		podman pod rm -f $podname
	fi
else
	echo "Pod doesn't exist"
fi

echo "Start pod..."
cd $DIR
podman play kube jellyfin-pod.yaml
echo "Start pod... done"
