#!/bin/bash

# Perform dev-system set up

HOME=$(readlink -f ~)
VIM_BUNDLE_DIR=~/.vim/bundle
REPO_DIR="${HOME}/repos"
TOR_URL="https://www.torproject.org/dist/torbrowser/8.0.1/tor-browser-linux64-8.0.1_en-US.tar.xz"

function updateSystem() {
    echo "== Updating"
    sudo apt-get -y update

    echo "== Upgrading"
    sudo apt-get -y upgrade

    echo "== Autoremove"
    sudo apt-get -y autoremove

    echo "== Installing dev packages"
    sudo apt-get -y install clang cmake cppcheck curl git vim tmux

    echo "== Autoremove"
    sudo apt-get -y autoremove
}

function installpathogen() {
    echo "== Checking for pathogen..."
    if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
        echo "=== Pathogen not found. Installing"
        mkdir -p ~/.vim/autoload ${VIM_BUNDLE_DIR}
        curl https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -o ~/.vim/autoload/pathogen.vim
    else
        echo "=== Pathogen already installed"
    fi
}

function installSyntastic() {
    echo "== Checking for syntastic..."
    if [ ! -d "${VIM_BUNDLE_DIR}/syntastic" ]; then
        echo "=== Syntastic not found. Installing"
        git clone --depth=1 https://github.com/scrooloose/syntastic.git $VIM_BUNDLE_DIR/syntastic
    else
        echo "=== Syntastic already installed"
    fi
}

function cloneSetup() {
    echo "== Cloning setup repo"
    mkdir $REPO_DIR; cd $REPO_DIR
    git clone https://github.com/akiraheid/setup.git

    SETUP_DIR="${REPO_DIR}/setup"
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
    ZIPPED_TOR="~/tmp/tor-browser-8.0.1.tar.xz"
    UNZIPPED_TOR="~/Download/tor-browser"
    echo "== Installing Tor"
    mkdir -p $UNZIPPED_TOR "~/tmp"
    sudo apt-get install -y curl
    curl -o $ZIPPED_TOR $TOR_URL
    tar -xzf $ZIPPED_TOR $UNZIPPED_TOR
    rm $ZIPPED_TOR
}

function installnpm() {
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install -y nodejs g++ gcc make
}

# Comment out options as desired
echo "== Beginning configuration"
updateSystem
cloneSetup
installpathogen
installSyntastic
installbashrc
installvimrc
#installDocker
installTor
installnpm
echo "== Done"
