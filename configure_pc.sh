#!/bin/bash
# Set up PC environment
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

	# Define where we expect this user's binaries to be
	USR_BIN_DIR=~/.local/bin
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

	d=~/.local/bin
	mkdir -p "${d}"
	cp --suffix="${date}" ./bin/oil "${d}/oil"
	cp --suffix="${date}" ./bin/syncthing "${d}/syncthing"
	info "Installed bash settings and tools"
}

# Install podman and settings
install_podman() {
	info "Installing podman and settings..."
	$SUDO apt-get install -y podman
	info "Installed podman and settings"
}

# Install vim and settings
install_vim() {
	info "Installing vim..."
	$SUDO apt-get -y install vim

	autoloadDir=${HOME}/.vim/autoload
	mkdir -p "${autoloadDir}"

	echo "Installing pathogen..."
	pathogen=/pathogen.vim
	if [ ! -f "${autoloadDir}/${pathogen}" ]; then
		cp "./vim/${pathogen}" "${autoloadDir}/${pathogen}"
	fi
	info "Installed vim and vim configuration"
}

# Install tmux and settings
install_tmux() {
	info "Installing tmux..."
	$SUDO apt-get -y install tmux
	info "Installed tmux and tmux configuration"
}

# Install decoaps and dependencies
install_decoaps() {
	info "Installing decoaps..."
	image=x11docker/xserver
	podman pull "docker.io/${image}:latest"
	sha=$(podman images | grep "${image}" | sed 's/\s\+/ /g' | cut -d ' ' -f 3)
	expected=b97c942d93c7
	if [ "$sha" != "${expected}" ]; then
		fatal "Hash of ${image} was '${sha}' instead of expected '${expected}'"
	fi

	# Work in the repos directory, since that's where I'll edit things anyway
	mkdir -p ~/repos
	pushd ~/repos

	git clone https://github.com/akiraheid/containerfiles.git
	pushd containerfiles
	./install black
	./install eslint
	./install gnucash
	./install keepassxc
	./install obsidian
	./install prettier
	./install pylint
	./install shellcheck
	./install signal
	popd # containerfiles
	popd # ~/repos
	info "Installed decoaps"
}

#setup_firewall() {
#    # Regardless of how dynamic your network environment may be, it is still
#    # useful to be familiar with the general idea behind each of the predefined
#    # zones for firewalld. In order from least trusted to most trusted, the
#    # predefined zones within firewalld are:
#    # drop: Any incoming network packets are dropped, there is no reply. Only
#    #       outgoing network connections are possible.
#    # block: Any incoming network connections are rejected with an
#    #        icmp-host-prohibited message for IPv4 and icmp6-adm-prohibited
#    #        for IPv6. Only network connections initiated within this system
#    #        are possible.
#    # public: For use in public areas. You do not trust the other computers on
#    #         networks to not harm your computer. Only selected incoming
#    #         connections are accepted.
#    # external: For use on external networks with IPv4 masquerading enabled
#    #           especially for routers. You do not trust the other computers on
#    #           networks to not harm your computer. Only selected incoming
#    #           connections are accepted.
#    # dmz: For computers in your demilitarized zone that are publicly-accessible
#    #      with limited access to your internal network. Only selected incoming
#    #      connections are accepted.
#    # work: For use in work areas. You mostly trust the other computers on
#    #       networks to not harm your computer. Only selected incoming
#    #       connections are accepted.
#    # home: For use in home areas. You mostly trust the other computers on
#    #       networks to not harm your computer. Only selected incoming
#    #       connections are accepted.
#    # internal: For use on internal networks. You mostly trust the other
#    #           computers on the networks to not harm your computer. Only
#    #           selected incoming connections are accepted.
#    # trusted: All network connections are accepted.
#    # https://firewalld.org/documentation/zone/predefined-zones.html
#
#    apt_install('firewalld')
#
#    def firewallcmd(args):
#        run(['firewall-cmd', '--permanent'] + args, check=True)
#
#    # By default, firewalld uses the public zone and has dhcpv6-client and ssh
#    # services running. Disable these because we don't host these services on
#    # PCs.
#    firewallcmd(['--remove-service', 'dhcpv6-client'])
#    firewallcmd(['--remove-service', 'ssh'])
#}

# Start configuration
{
	setup_env
	update_system
	install_bash_settings
	install_tmux
	install_vim
	install_podman
	install_decoaps
}
