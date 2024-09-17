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

ubuntu() {
	NAME=ubuntu

	stopdel $NAME

	podman run --rm -it --name $NAME $NAME:latest
}
