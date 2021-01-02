#!/bin/bash

# Functions to run podman containers

stopdel() {
	podman stop -i $1
	podman rm -i $1
}

alpine() {
	NAME=alpine

	stopdel $NAME

	podman run --rm -it --name $NAME $NAME:latest
}

keepassxc() {
	NAME=keepassxc

	stopdel $NAME

	podman run -d --rm \
		--name $NAME \
		-e DISPLAY=unix${DISPLAY} \
		-v ${HOME}/.config/keepassxc/:/root/.config/keepassxc/ \
		-v ${HOME}/syncthing/computers/keepassxc.kdbx:/root/.config/keepassxc/keepassxc.kdbx \
		-v /etc/machine-id:/etc/machine-id:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /usr/share/X11/xkb/:/usr/share/X11/xkb/:ro \
		localhost/keepassxc
}

syncthing() {
	NAME=syncthing

	stopdel $NAME

	DIR=~/syncthing
	mkdir -p $DIR

	# normally runs with port mappings -p 8384:8384 -p 22000:22000 but using
	# --network=host eliminates the need to specify the mappings
	podman run -d --rm \
		-e PUID="`id -u`" \
		-e PGID="`id -g`" \
		-e STGUIADDRESS="" \
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
