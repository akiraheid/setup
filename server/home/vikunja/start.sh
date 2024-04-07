#!/bin/bash
set -e

date --iso-8601

DIR=$(dirname `readlink -f $0`)

name=vikunja
echo "Searching for pod with name ${name}..."
podline=`podman pod ps | grep $name | sed 's/\s\+/ /g'`
podname=`echo "$podline" | cut -d ' ' -f 2`

if [ -n "$podname" ] ; then
	podstatus=`echo "$podline" | cut -d ' ' -f 3`
	echo "Pod ${podname} exists"
	echo "Check if running"
	if [ "$podstatus" != "Running" ]; then
		podman pod rm -f $podname
	else
		echo "Pod ${podname} is already running. Exiting"
		exit 0
	fi
else
	echo "Pod with name ${name} doesn't exist"
fi

echo "Start deployment ${name}..."
cd $DIR
podman play kube deployment.yaml
echo "Start deployment ${name}... done"
