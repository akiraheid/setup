#!/usr/bin/env bash
set -ex

mkdir -p /mnt/{ollama,openwebui}/data

app=openwebui
podman pod exists "$app" \
	|| podman pod create --name "$app" \
		-p 8086:8080 \
		-p 11434:11434

podman run -d \
	--name ollama \
	--pod "$app" \
	--restart always \
	-v /mnt/ollama/data/:/root/.ollama/:rw \
	docker.io/ollama/ollama:0.9.2

podman run -d \
	-e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
	--name open-webui \
	--pod "$app" \
	--restart always \
	-v /mnt/openwebui/data:/app/backend/data/:rw \
	ghcr.io/open-webui/open-webui:0.6.15
