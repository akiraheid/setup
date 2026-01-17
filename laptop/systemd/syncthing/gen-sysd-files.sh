#!/bin/bash
set -ex

echo "Generate Syncthing systemd unit file..."
SVC_NAME=syncthing

dataDir=~/syncthing
mkdir -p "${dataDir}"

# Delete -e STGUIADDRESS="" line to enable GUI
# normally runs with port mappings -p 8384:8384 -p 22000:22000 but using
# --network=host eliminates the need to specify the mappings
podman create --name "$SVC_NAME" \
	-e PUID="$(id -u)" \
	-e PGID="$(id -g)" \
	--network=host \
	--userns=keep-id \
	--volume "${dataDir}/:/var/syncthing/" \
	docker.io/syncthing/syncthing:2.0.13

podman generate systemd --new --name "${SVC_NAME}" > "${SVC_NAME}.service"
podman rm "${SVC_NAME}"

