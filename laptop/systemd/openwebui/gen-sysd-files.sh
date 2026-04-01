#!/bin/bash
set -ex

echo "Generate Ollama systemd unit file..."
podman create --name ollama \
    -e "OLLAMA_CONTEXT_LENGTH=130000" \
    -p "11434:11434" \
	--cpus=15 \
	--memory=30g \
	--memory-reservation=15g \
	-v "ollama-data:/root/.ollama:rw" \
    docker.io/ollama/ollama:0.19.0-rocm

podman generate systemd --new --name ollama > "ollama.service"
podman rm ollama

echo "Generate OpenWebUI systemd unit file..."
podman create --name openwebui \
    -e "OLLAMA_BASE_URLS=http://host.containers.internal:11434" \
    -p "8080:8080" \
	--cpus=2 \
	--memory=1g \
	--memory-reservation=500m \
    -v "openwebui-data:/app/backend/data:rw" \
    ghcr.io/open-webui/open-webui:v0.8.12

podman generate systemd --new --name openwebui > "openwebui.service"
podman rm openwebui
