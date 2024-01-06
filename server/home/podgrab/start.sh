#!/bin/bash
set -e

date -u

DIR=$(dirname `readlink -f $0`)

if grep CHANGEME $DIR/pod.yaml ; then
	echo "Must change default password"
	exit 1
fi

# Use "podgrab_pod" because podman will rename the pod if a container in the pod
# has the same name
podname=podgrab-pod
if podman pod exists $podname ; then
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
podman play kube pod.yaml
echo "Start pod... done"
