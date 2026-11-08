#!/usr/bin/env bash
# Set up VIM

set -ex

this_file=$(readlink -f "$0")
this_dir=$(dirname "${this_file}")
common_dir=${this_dir}/../common
sudo=

. "${common_dir}"/check_sudo.sh
. "${common_dir}"/logging.sh

install_pathogen() {
	cp "${common_dir}/vim/pathogen.vim" "${HOME}/.vim/autoload"
}

install_plugins() {
	local version=3.10.0
	local zipfile=syntastic-${version}.tar.gz
	local tmpdir
	tmpdir=$(mktemp -d)
	cd "${tmpdir}"

	if [ ! -f "$zipfile" ]; then
		wget -O "$zipfile" "https://github.com/vim-syntastic/syntastic/archive/refs/tags/${version}.tar.gz"
	fi

	sha256sum -c "${common_dir}/vim/plugins.sha256"

	local bundledir=${HOME}/.vim/bundle
	mkdir -p "${bundledir}"
	tar -xf "$zipfile" -C "${bundledir}/"
}

install_vim() {
	if command -v vim; then
		return
	fi
	$sudo apt-get install -y vim
}

install_vimrc() {
	baksuffix=$(date +%Y%m%d-%H%M%S)
	homevimrc="${HOME}/.vimrc"

	# Back up existing .vimrc
	if [[ -f "${homevimrc}" ]]; then
		cp "${homevimrc}" "${homevimrc}-${baksuffix}"
	fi

	cp "${common_dir}/vim/vimrc" "${homevimrc}"
}

{
	check_sudo
	install_vim
	install_vimrc
	install_pathogen
	install_plugins
}
