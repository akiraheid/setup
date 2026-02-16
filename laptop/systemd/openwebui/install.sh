#!/usr/bin/env bash
# Install OpenWebUI and Ollama as a systemd service.

set -ex

info() {
	echo "[INFO] $1"
}

THIS_DIR=$(dirname "$(readlink -f "$0")")
SYSD_DIR=~/.config/systemd/user

info "Installing Ollama..."
cp "${THIS_DIR}/ollama.service" "${SYSD_DIR}/"

systemctl --user start ollama.service
systemctl --user is-active ollama.service
systemctl --user enable ollama.service

info "Installing OpenWebUI..."
cp "${THIS_DIR}/openwebui.service" "${SYSD_DIR}/"
systemctl --user start openwebui.service
systemctl --user is-active openwebui.service
systemctl --user enable openwebui.service

info "Done!"

