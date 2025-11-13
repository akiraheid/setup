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
	date=$(date +%Y%m%d-%H%M%S)
	cp --suffix="${date}" ./vim/vimrc ~/.vimrc
	info "Installed vim and vim configuration"

	autoloadDir=${HOME}/.vim/autoload
	bundleDir=${HOME}/.vim/bundle
	mkdir -p "$autoloadDir" "$bundleDir"

	info "Installing vim plugins..."
	pathogen=pathogen.vim
	if [ ! -f "${autoloadDir}/${pathogen}" ]; then
		cp "./vim/${pathogen}" "${autoloadDir}/${pathogen}"
	fi
	tmpdir=$(mktemp -d)
	cp ./vim/plugins.sha256 "${tmpdir}/"
	pushd "$tmpdir"

	cfn=syntastic.tar.gz
	v=3.10.0
	if [ ! -f "$cfn" ]; then
		wget -O "$cfn" "https://github.com/vim-syntastic/syntastic/archive/refs/tags/${v}.tar.gz"
	fi

	sha256sum -c plugins.sha256

	info "Installing syntastic"
	tar -xf "$cfn" -C "${bundleDir}/"

	pushd "$bundleDir"
	mv "syntastic-${v}" "syntastic"
	popd # bundleDir

	popd # tmpdir
	rm -r "$tmpdir"
	info "Installed vim plugins"
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
	mkdir -p "${HOME}/repos"
	pushd "${HOME}/repos"

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

# Avahi is used for mDNS to resolve hosts via [hostname].local without a DNS
# DNS server on the local network.
setup_mDNS() {
	$SUDO apt-get install -y avahi-daemon libnss-mdns
}

# Set up wireguard for connecting to the NAS via NFS.
setup_wireguard() {
	# Configuring based on https://d.sb/2020/12/nfs-howto
	info "Installing wireguard"
	$SUDO apt-get install -y wireguard

	local wg_dir
	local prikey
	local pubkey
	wg_dir=/etc/wireguard
	prikey=${wg_dir}/wg-privatekey
	pubkey=${wg_dir}/wg-publickey
	mkdir -p "${wg_dir}"

	wg genkey | $SUDO tee "${prikey}" | wg pubkey | $SUDO tee "${pubkey}"

	cat << EOF > "${wg_dir}/wg0.conf"
[Interface]
Address = 10.222.0.2/24
PrivateKey = $($SUDO cat ${prikey})
ListenPort = 51820
EOF
	info "Each peer must still be added to the ${wg_dir}/wg0.conf file under"
	info "a [Peer] section. For example:"
	info "  [Peer]"
	info "  PublicKey = abcdefghijklmnopqrstuvwxyz="
	info "  Endpoint = hostname.local:51820"
	info "  AllowedIPs = 10.222.0.1/32"
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
	setup_mDNS
	setup_wireguard
	info "Restart computer to use kubectl"
}
