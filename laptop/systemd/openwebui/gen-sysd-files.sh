#!/bin/bash
set -ex

echo "Generate Ollama systemd unit file..."
podman create --name ollama \
    -e "OLLAMA_CONTEXT_LENGTH=130000" \
    -p "11434:11434" \
	--cpus=7 \
	--memory=15g \
	--memory-reservation=10g \
	-v "ollama-data:/root/.ollama:rw" \
    docker.io/ollama/ollama:0.13.5

podman generate systemd --new --files --name ollama

echo "Generate OpenWebUI systemd unit file..."
podman create --name openwebui \
    -e "OLLAMA_BASE_URLS=http://localhost:11434" \
    -p "8080:8080" \
	--cpus=2 \
	--memory=1g \
	--memory-reservation=500m \
    -v "openwebui-data:/app/backend/data:rw" \
    ghcr.io/open-webui/open-webui:v0.6.43

podman generate systemd --new --files --name openwebui

