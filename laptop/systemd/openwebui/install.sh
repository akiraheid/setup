#!/usr/bin/env bash
# Install OpenWebUI as a systemd service.

set -ex

info() {
	echo "[INFO] $1"
}

THIS_DIR=$(dirname "$(readlink -f "$0")")
OWU_DIR=~/.config/systemd/user
OWU_POD=${OWU_DIR}/pod-openwebui.yaml

info "Installing service"
cp "${THIS_DIR}/pod.yaml" "${OWU_POD}"

escaped=$(systemd-escape "${OWU_POD}")
svc_name="podman-kube@${escaped}.service"

systemctl --user start "${svc_name}"
systemctl --user is-active "${svc_name}"

systemctl --user enable "${svc_name}"

