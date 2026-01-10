#!/bin/bash
set -ex

echo "Generate Home Assistant systemd unit file..."
SVC_NAME=home-assistant

podman create --name "${SVC_NAME}" \
	-p 8123:8123 \
	-v "${SVC_NAME}-config:/config" \
	ghcr.io/home-assistant/home-assistant:2025.12.5

podman generate systemd --new --name "${SVC_NAME}" > "${SVC_NAME}.service"
podman rm "${SVC_NAME}"

