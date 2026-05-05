#!/bin/bash
set -ex

this_dir=$(dirname "$(readlink -f "$0")")
cd "$this_dir"

echo "Generate Ollama systemd unit file..."
# --memory is 10g because the machine uses shared memory (RAM + GPU VRAM)
podman create --name ollama \
	--cpus=15 \
	--device /dev/kfd \
	--device /dev/dri \
    -e "OLLAMA_CONTEXT_LENGTH=130000" \
	--group-add keep-groups \
	--memory=10g \
	--memory-reservation=2g \
	-p "11434:11434" \
	-v "ollama-data:/root/.ollama:rw" \
    docker.io/ollama/ollama:0.23.0-rocm

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
    ghcr.io/open-webui/open-webui:v0.9.2

podman generate systemd --new --name openwebui > "openwebui.service"
podman rm openwebui

echo "Generate OpenTerminal systemd unit file..."
name=openterminal
podman create --name "${name}" \
    -e "OPEN_TERMINAL_API_KEY=MySuperSecretKey294" \
    -p "8082:8000" \
    -v "openterminal:/home/user:rw" \
	ghcr.io/open-webui/open-terminal:0.11.34

podman generate systemd --new --name "${name}" > "${name}.service"
podman rm "${name}"
