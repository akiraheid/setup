#!/bin/bash
# Download the repo and execute the PC configuration script
#
# This script is meant to be run via
#   curl -o- https://github.com/akiraheid/setup/master/pc.sh | bash
set -e

info() {
    echo '[INFO] ' "$@"
}
warn() {
    echo '[WARN] ' "$@" >&2
}
fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# Define needed environment variables
setup_env() {
    # Use sudo if we are not already root
    SUDO=sudo
    if [ $(id -u) -eq 0 ]; then
        SUDO=
    fi
}

# Update system
update_system() {
	info "Updating system"
	$SUDO apt-get -y update
	$SUDO apt-get -y upgrade
	$SUDO apt-get -y dist-upgrade
	$SUDO apt-get -y autoremove
	info "System updated"
}

# Install git
install_git() {
	which_cmd=$(command -v git 2>/dev/null || true)
	if [ -z "${which_cmd}" ]; then
		info "Installing git"
		$SUDO apt-get install -y git
	else
		info "Skipping git install, command exists in PATH at ${which_cmd}"
	fi
}

# Clone the repo to execute the configuration script
clone_repo() {
	git clone --depth 1 https://github.com/akiraheid/setup.git
}

# Execute the configuration script
run_script() {
	cd setup
	chmod 700 configure_pc.sh
	./configure_pc.sh
}

# Start configuration
{
	setup_env
	update_system
	install_git
	clone_repo
	run_script
}
