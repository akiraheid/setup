#!/bin/bash
set -ex

this_dir=$(dirname "$(readlink -f "$0")")
cd "$this_dir"

echo "Generate Ollama systemd unit file..."
# --memory is 1g because the machine uses shared memory (RAM + GPU VRAM) and the
# GPU is already set to use 90% of the memory.
podman create --name ollama \
	--cpus=15 \
	--device /dev/kfd \
	--device /dev/dri \
	-e "OLLAMA_CONTEXT_LENGTH=130000" \
	--group-add keep-groups \
	--memory=1g \
	--memory-reservation=500m \
	-p "11434:11434" \
	--replace \
	-v "ollama-data:/root/.ollama:rw" \
	docker.io/ollama/ollama:0.23.0-rocm

podman generate systemd --new --name ollama > "ollama.service"
podman rm ollama

echo "Generate OpenWebUI systemd unit file..."
podman create --name openwebui \
	--cpus=2 \
	-e "OLLAMA_BASE_URLS=http://host.containers.internal:11434" \
	-p "8080:8080" \
	--memory=1g \
	--memory-reservation=500m \
	--replace \
	-v "openwebui-data:/app/backend/data:rw" \
	ghcr.io/open-webui/open-webui:v0.9.5

podman generate systemd --new --name openwebui > "openwebui.service"
podman rm openwebui

echo "Generate OpenTerminal systemd unit file..."
zenDataDir=${HOME}/Documents/zen-data
mkdir -p "${zenDataDir}"
name=openterminal
podman create --name "${name}" \
	--cpus=1 \
	-e "OPEN_TERMINAL_API_KEY=MySuperSecretKey294" \
	--memory=500m \
	--memory-reservation=250m \
	-p "8082:8000" \
	--replace \
	-v "${zenDataDir}:/home/user:rw" \
	ghcr.io/open-webui/open-terminal:0.11.34

podman generate systemd --new --name "${name}" > "${name}.service"
podman rm "${name}"

echo "Generate Kokoro systemd unit file..."
name=kokoro
podman create --name "${name}" \
	--cpus=15 \
	--memory=10g \
	--memory-reservation=500m \
	-p "8880:8880" \
	--replace \
	ghcr.io/remsky/kokoro-fastapi-cpu:v0.3.0

podman generate systemd --new --name "${name}" > "${name}.service"
podman rm "${name}"
