#!/usr/bin/env bash
# Install OpenWebUI and Ollama as a systemd service.

set -ex

info() {
	echo "[INFO] $1"
}

THIS_DIR=$(dirname "$(readlink -f "$0")")
SYSD_DIR=~/.config/systemd/user

load_service() {
	mv "${THIS_DIR}/${1}.service" "${SYSD_DIR}/"
	systemctl --user daemon-reload
	systemctl --user start "${1}.service"
	systemctl --user is-active "${1}.service"
	systemctl --user enable "${1}.service"
}

info "Installing Ollama..."
load_service ollama

info "Installing OpenWebUI..."
load_service openwebui

info "Installing OpenTerminal..."
load_service openterminal

info "Installing Kokoro..."
load_service kokoro

info "Done!"

