#!/bin/bash

# Functions to run podman containers

# Force delete (if exists) the container with the specified name or ID
stopdel() {
	EXISTS=`podman ps -a --format '{{.Names}}' | grep "$1"`
	if [ -n "$EXISTS" ]; then
		echo "Found container $1. Deleting"
		podman rm -f "$1"
	fi
}

alpine() {
	NAME=alpine

	stopdel $NAME

	podman run --rm -it --name $NAME $NAME:latest
}

syncthing() {
	NAME=syncthing

	stopdel $NAME

	DIR=~/syncthing
	mkdir -p $DIR

	# Delete -e STGUIADDRESS="" line to enable GUI
	# normally runs with port mappings -p 8384:8384 -p 22000:22000 but using
	# --network=host eliminates the need to specify the mappings
	podman run -d --rm \
		-e PUID="`id -u`" \
		-e PGID="`id -g`" \
		--name syncthing \
		--network=host \
		--userns=keep-id \
		--volume $DIR/:/var/syncthing/ \
		syncthing/syncthing:latest
}

ubuntu() {
	NAME=ubuntu

	stopdel $NAME

	podman run --rm -it --name $NAME $NAME:latest
}
