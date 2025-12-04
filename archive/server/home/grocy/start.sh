#!/bin/bash
set -e

date --iso-8601

DIR=$(dirname `readlink -f $0`)

name=grocy
echo "Check for existing pod..."

if podman pod exists $name ; then
	echo "Pod exists"
	echo "Check if running"
	podstatus=`podman pod ps | grep $name | sed 's/\s\+/ /g' | cut -d ' ' -f 3`
	if [ "$podstatus" != "Running" ]; then
		podman pod rm -f $name
	else
		echo "Pod is already running. Exiting"
		exit 0
	fi
else
	echo "Pod doesn't exist"
fi

echo "Start pod..."
cd $DIR
podman play kube pod.yaml
echo "Start pod... done"
