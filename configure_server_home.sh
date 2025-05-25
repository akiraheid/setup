#!/bin/bash
# Set up home server environment
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
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=
    fi
}

# Update system
update_system() {
	info "Updating system..."
	$SUDO ./bash/updateSystem
	info "System updated"
}

# Install bash settings
install_bash_settings() {
	info "Installing bash settings and tools..."
	date=$(date +%Y%m%d-%H%M%S)
	cp --suffix="${date}" ./bash/bashrc ~/.bashrc
	cp --suffix="${date}" ./bash/bash_aliases ~/.bash_aliases
	cp --suffix="${date}" ./bash/bash_functions ~/.bash_functions
	cp --suffix="${date}" ./bash/bash_profile ~/.bash_profile
	cp --suffix="${date}" ./bash/profile ~/.profile

	d=${HOME}/.local/bin
	mkdir -p "${d}"
	info "Installed bash settings and tools"
}

# Install vim and settings
install_vim() {
	info "Installing vim..."
	$SUDO apt-get -y install vim
	date=$(date +%Y%m%d-%H%M%S)
	cp --suffix="${date}" ./vim/vimrc ~/.vimrc
	info "Installed vim and vim configuration"
}

# Start configuration
{
	setup_env
	update_system
	install_bash_settings
	install_vim
}
