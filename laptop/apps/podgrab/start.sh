#!/bin/bash
set -e

containerName=podgrab

check_running() {
	if podman ps --format '{{.Names}}' | grep -q "${containerName}"; then
		exit 0
	fi
}

clean() {
	if podman ps -a --format '{{.Names}}' | grep -q "${containerName}"; then
		podman rm -f "${containerName}"
	fi
}

start() {
	app=podgrab
	appDir=${HOME}/Downloads/${app}
	configDir=${XDG_CONFIG_HOME:-$HOME/.config/${app}}
	downloadDir=${appDir}/download

	mkdir -p "$configDir" "$downloadDir"

	podman run --rm -d \
		--cpus=1 \
		--memory=500m \
		--name "${containerName}" \
		-p 8083:8080 \
		--pull=missing \
		-v "${configDir}:/config" \
		-v "${downloadDir}:/assets" \
		docker.io/akhilrex/podgrab:1.0.0
}

{
	check_running
	clean
	start
}
