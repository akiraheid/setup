#!/usr/bin/env bash
# Install Home Assistant as a systemd service.

set -ex

info() {
	echo "[INFO] $1"
}

init() {
	info "Initializing..."
	SVC_NAME=home-assistant
	THIS_DIR=$(dirname "$(readlink -f "$0")")
	SYSD_DIR=~/.config/systemd/user
	mkdir -p "${SYSD_DIR}"
}

install() {
	info "Installing Home Assistant..."
	cp "${THIS_DIR}/${SVC_NAME}.service" "${SYSD_DIR}/"

	systemctl --user daemon-reload
	systemctl --user start "${SVC_NAME}.service"
	systemctl --user is-active "${SVC_NAME}.service"
	systemctl --user enable "${SVC_NAME}.service"

	info "Done!"
}

{
	init
	install
}

