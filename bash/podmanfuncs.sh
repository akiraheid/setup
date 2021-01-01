#!/bin/bash

# Functions to run podman containers

keepassxc() {
	NAME=keepassxc

	podman stop -i $NAME
	podman rm -i $NAME

	podman run -d --rm \
		--name $NAME \
		-e DISPLAY=unix${DISPLAY} \
		-v ${HOME}/.config/keepassxc/:/root/.config/keepassxc/ \
		-v /etc/machine-id:/etc/machine-id:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /usr/share/X11/xkb/:/usr/share/X11/xkb/:ro \
		localhost/keepassxc
}
