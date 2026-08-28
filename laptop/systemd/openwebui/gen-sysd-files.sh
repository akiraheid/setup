#!/bin/bash
set -ex

this_dir=$(dirname "$(readlink -f "$0")")
cd "$this_dir"

echo "Generate Ollama systemd unit file..."
# --memory is 1g because the machine uses shared memory (RAM + GPU VRAM) and the
# GPU is already set to use 90% of the memory.
#
# OLLAMA_KV_CACHE_TYPE=q8_0 per Ollama recommendation takes half the memory with
# only slight loss in precision.
# https://docs.ollama.com/faq#how-can-i-set-the-quantization-type-for-the-k/v-cache
podman create --name ollama \
	--cpus=15 \
	--device /dev/kfd \
	--device /dev/dri \
	-e "OLLAMA_KV_CACHE_TYPE=q8_0" \
	--group-add keep-groups \
	--memory=1g \
	--memory-reservation=500m \
	-p "11434:11434" \
	--replace \
	-v "ollama-data:/root/.ollama:rw" \
	docker.io/ollama/ollama:0.24.0-rocm

podman generate systemd --new --name ollama > "ollama.service"
podman rm ollama

echo "Generate OpenWebUI systemd unit file..."
# Disable ENABLE_MEMORY_SYSTEM_CONTEXT to prevent injecting memories into the
# system prompt and invalidating the KV-cache
podman create --name openwebui \
	--cpus=2 \
	-e "ENABLE_MEMORY_SYSTEM_CONTEXT=false" \
	-e "OLLAMA_BASE_URLS=http://host.containers.internal:11434" \
	-p "8080:8080" \
	--memory=1g \
	--memory-reservation=500m \
	--replace \
	-v "openwebui-data:/app/backend/data:rw" \
	ghcr.io/open-webui/open-webui:v0.11.0

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

echo "Generate Open WebUI Computer systemd unit file..."
name=open-computer
podman create --name "${name}" \
	--cpus=2 \
	--memory=1g \
	--memory-reservation=500m \
	-p "8084:8000" \
	--replace \
	-v "open-computer-data:/data:rw" \
	-v "open-computer-workspace:/workspace:rw" \
	-w "/workspace" \
	ghcr.io/open-webui/computer:0.9.21

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
	ghcr.io/remsky/kokoro-fastapi-cpu:v0.5.0

podman generate systemd --new --name "${name}" > "${name}.service"
podman rm "${name}"
