#!/usr/bin/env bash
# Install OpenWebUI and Ollama as a systemd service.

set -ex

info() {
	echo "[INFO] $1"
}

THIS_DIR=$(dirname "$(readlink -f "$0")")
SYSD_DIR=~/.config/systemd/user

info "Installing Ollama..."
cp "${THIS_DIR}/container-ollama.service" "${SYSD_DIR}/"

systemctl --user start container-ollama.service
systemctl --user is-active container-ollama.service
systemctl --user enable container-ollama.service

info "Installing OpenWebUI..."
cp "${THIS_DIR}/container-openwebui.service" "${SYSD_DIR}/"
systemctl --user start container-openwebui.service
systemctl --user is-active container-openwebui.service
systemctl --user enable container-openwebui.service

info "Done!"

