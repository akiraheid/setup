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
	-e "OLLAMA_IGPU_ENABLE=1" \
	-e "OLLAMA_KV_CACHE_TYPE=q8_0" \
	--group-add keep-groups \
	--memory=1g \
	--memory-reservation=500m \
	-p "11434:11434" \
	--replace \
	-v "ollama-data:/root/.ollama:rw" \
	docker.io/ollama/ollama:0.32.5-rocm

podman generate systemd --new --name ollama > "ollama.service"
podman rm ollama

echo "Generate Open WebUI Computer systemd unit file..."
name=opencomputer
skills_dir=${HOME}/Documents/opencomputer/skills
data_dir=${HOME}/Documents/opencomputer/data
readonly_dir=${HOME}/Documents/opencomputer/readonly
workspace_dir=${HOME}/Documents/opencomputer/workspace
mkdir -p "${data_dir}" "${readonly_dir}" "${skills_dir}" "${workspace_dir}"
podman create --name "${name}" \
	--cpus=2 \
	--memory=1g \
	--memory-reservation=500m \
	-p "8084:8000" \
	--replace \
	--userns=keep-id \
	--user="$(id -u):$(id -g)" \
	-v "${data_dir}:/data:rw" \
	-v "${readonly_dir}:/readonly:ro" \
	-v "${skills_dir}:/home/cptr/.agents/skills:rw" \
	-v "${workspace_dir}:/workspace:rw" \
	-w "/workspace" \
	docker.io/akiraheid/openwebui-computer:0.0.1

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
