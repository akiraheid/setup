#!/bin/bash

# Perform dev-system set up

HOME=$(readlink -f ~)
VIM_BUNDLE_DIR=~/.vim/bundle
REPO_DIR="${HOME}/repos"
SETUP_DIR="${REPO_DIR}/setup"

function checkInstall() {
	if ! command -v $1; then
		sudo apt-get install -y $1
	fi
}

function updateSystem() {
	echo "== Updating"
	sudo apt-get -y update

	echo "== Upgrading"
	sudo apt-get -y upgrade

	echo "== Autoremove"
	sudo apt-get -y autoremove

	echo "== Installing dev packages"
	sudo apt-get -y install curl g++ gcc git make tmux vim

	echo "== Autoremove"
	sudo apt-get -y autoremove
}

function installpathogen() {
	echo "== Checking for pathogen..."
	if [ -f ~/.vim/autoload/pathogen.vim ]; then
		echo "=== Pathogen already installed"
		return
	fi

	echo "=== Pathogen not found. Installing"
	mkdir -p ~/.vim/autoload ${VIM_BUNDLE_DIR}
	curl https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -o ~/.vim/autoload/pathogen.vim
}

function installSyntastic() {
	echo "== Checking for syntastic..."
	if [ ! -d "${VIM_BUNDLE_DIR}/syntastic" ]; then
		echo "=== Syntastic already installed"
		return
	fi

	checkInstall git
	echo "=== Syntastic not found. Installing"
	git clone --depth=1 https://github.com/scrooloose/syntastic.git $VIM_BUNDLE_DIR/syntastic
}

function installeslint() {
	echo "== Checking for eslint..."
	if [ command -v eslint ]; then
		echo "=== eslint already installed"
		return
	fi

	echo "=== eslint not found. Installing"
	if ! command -v npm; then
		installnpm
	fi
	npm i -g eslint
}

function cloneSetup() {
	checkInstall git

	echo "== Cloning setup repo"
	mkdir $REPO_DIR; cd $REPO_DIR
	git clone https://github.com/akiraheid/setup.git
	echo "setup repo cloned to $REPO_DIR"
}

function installbashrc() {
	echo "== Installing .bashrc..."
	BASHRC="${HOME}/.bashrc"
	if [ -f ${BASHRC} ]; then
		echo "=== .bashrc exists. Creating backup: .bashrc.bak"
		mv ${BASHRC} "${BASHRC}.bak" >/dev/null 2>&1
	fi
	echo "=== Creating symlink to bashrc"
	ln -s "${SETUP_DIR}/bashrc" ${BASHRC}
}

function installvimrc() {
	echo "== Installing .vimrc"
	VIMRC="${HOME}/.vimrc"
	if [ -f $VIMRC ]; then
		echo "=== .vimrc exists. Creating backup: .vimrc.bak"
		mv ${VIMRC} "${VIMRC}.bak" >/dev/null 2>&1
	fi
	ln -s "${SETUP_DIR}/vimrc" ${VIMRC}
}

function installDocker() {
	checkInstall curl

	echo "== Installing Docker"
	sudo apt-get remove -y docker docker-engine docker.io
	echo "=== Install dependencies"
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	echo "=== Add docker repository"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	echo "=== Install docker"
	sudo apt-get update; sudo apt-get install -y docker-ce;
	echo "=== Test docker"
	sudo docker run hello-world
}

function installTor() {
	TOR_VERSION=8.0.1
	TOR_URL="https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz"
	ZIPPED_TOR="~/tmp/tor-browser-${TOR_VERSION}.tar.xz"
	UNZIPPED_TOR="~/Download/tor-browser"

	checkInstall curl

	echo "== Installing Tor"
	mkdir -p $UNZIPPED_TOR "~/tmp"
	curl -o $ZIPPED_TOR $TOR_URL
	tar -xzf $ZIPPED_TOR $UNZIPPED_TOR
	rm $ZIPPED_TOR
}

function installnpm() {
	echo "== Checking for npm..."
	if command -v npm; then
		echo "=== npm already installed"
		return
	fi

	echo "=== npm not found. Installing"
	checkInstall curl
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
	$(nvm install node)
}

# Comment out options as desired
echo "== Beginning configuration"
updateSystem
cloneSetup
installbashrc
installvimrc
#installpathogen
#installSyntastic
#installnpm
#installeslint
#installDocker
#installTor
echo "== Done"
