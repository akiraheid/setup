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

gimp() {
	stopdel gimp
	podman run -d --rm --name gimp \
		-e DISPLAY=unix$DISPLAY \
		-v $HOME/Pictures:/root/Pictures \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /usr/share/fonts/:/usr/share/fonts:ro \
		akiraheid/gimp
}

# Start a KeepassXC container.
# Optional file argument will open a specific file in a unnamed container.
keepassxc() {
	# Stop the existing container if a file is not specified
	if [ $# == 0 ]; then
		stopdel keepassxc
	fi

	ARG="/root/.config/keepassxc/keepassxc.kdbx"
	NAME="--name keepassxc"
	VOL=""
	if [ $# == 1 ]; then
		ARG="/root/data/$(basename $1)"
		NAME=""
		VOL="-v $(readlink -f $1):$ARG"
	fi

	podman run -d --rm $NAME \
		-e DISPLAY=unix${DISPLAY} \
		-v ${HOME}/syncthing/computers/keepassxc/:/root/.config/keepassxc/ \
		-v /etc/machine-id:/etc/machine-id:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /usr/share/X11/xkb/:/usr/share/X11/xkb/:ro \
		$VOL \
		localhost/keepassxc $ARG
}

openoffice-calc() {
	NAME=openoffice-calc

	if [ $# != 0 ]; then
		VOL="-v $(readlink -f $1):/root/data/$(basename $1)"
		ARG="/root/data/$1"
	else
		ARG=""
	fi
	podman run -d --rm \
		-e DISPLAY=unix${DISPLAY} \
		--name ${NAME} \
		-v ${HOME}/.config/openoffice:/root/.openoffice:rw \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /usr/share/X11/xkb/:/usr/share/X11/xkb/:ro \
		$VOL \
		akiraheid/openoffice-calc $ARG
}
oocalc() {
	openoffice-calc $@
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
