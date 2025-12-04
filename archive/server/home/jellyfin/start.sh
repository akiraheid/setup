#!/bin/bash
set -e

date -u

DIR=$(dirname `readlink -f $0`)

podname=jellyfin
echo "Check for existing pod..."

set +e
if podman pod exists $podname ; then
	set -e
	# Use spaces around the pod name to ensure no substrings are matched
	podstatus=`podman pod ps | grep " $podname " | sed 's/\s\+/ /g' | cut -d ' ' -f 3`

	if [ "$podstatus" == "Running" ]; then
		echo "Pod already running. Exiting"
		exit 0
	else
		echo "Found non-running pod. Deleting"
		podman pod rm -f $podname
	fi
else
	set -e
	echo "Pod doesn't exist"
fi

echo "Start pod..."
cd $DIR
podman play kube pod.yaml
echo "Start pod... done"
