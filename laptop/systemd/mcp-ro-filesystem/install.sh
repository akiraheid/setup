#!/usr/bin/env bash
# Install filesystem MCP as a systemd service.

set -ex

info() {
	echo "[INFO] $1"
}

init() {
	THIS_DIR=$(dirname "$(readlink -f "$0")")
	SVC_NAME=mcp-readonly-filesystem
	RO_DIR=~/${SVC_NAME}
	SVC_FP=~/.config/systemd/user/${SVC_NAME}.service

	mkdir -p "${RO_DIR}"
}

generate_service() {
	info "Generating systemd service unit..."
	podman create --name "${SVC_NAME}" \
		-p "8081:8080" \
		-v "${RO_DIR}/:/usr/data/:ro" \
		-w "/usr/data/" \
		docker.io/akiraheid/rust-mcp-filesystem:0.3.8 /usr/data

	# Generate the systemd unit file here because RO_DIR will be different based
	# on the user name.
	podman generate systemd --restart-policy=always --new --name \
		"${SVC_NAME}" > "${THIS_DIR}/${SVC_NAME}.service"

	podman rm "${SVC_NAME}"
}

install_service() {
	info "Installing service..."
	mv "${THIS_DIR}/${SVC_NAME}.service" "${SVC_FP}"
	systemctl --user start "${SVC_NAME}"
	systemctl --user is-active "${SVC_NAME}"
	systemctl --user enable "${SVC_NAME}"
}

{
	init
	generate_service
	install_service
	info "Done!"
}
