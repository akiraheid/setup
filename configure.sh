#!/bin/bash

# Perform dev-system set up.

if [ -z "${SETUP_DIR}" ]; then
  read -p "What is the path to the setup repo?" path
  SETUP_DIR=$(readlink -f ${path})
  echo "Using ${SETUP_DIR} as repo path"
fi

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

echo "== Checking for pathogen..."
VIM_BUNDLE_DIR=~/.vim/bundle
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  echo "==== Pathogen not found. Installing"
  mkdir -p ~/.vim/autoload ${VIM_BUNDLE_DIR}
  curl https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -o ~/.vim/autoload/pathogen.vim
else
  echo "==== Pathogen already installed"
fi

echo "== Installing vim packages..."
if [ ! -d "${VIM_BUNDLE_DIR}/syntastic" ]; then
  echo "==== Syntastic not found. Installing"
  git clone --depth=1 https://github.com/scrooloose/syntastic.git $VIM_BUNDLE_DIR/syntastic
fi

HOME=$(readlink -f ~)

echo "== Installing .bashrc..."
BASHRC="${HOME}/.bashrc"
cp ${BASHRC} "${BASHRC}.bak" >/dev/null 2>&1
rm ${BASHRC} >/dev/null 2>&1
ln -s "${SETUP_DIR}/bashrc" ${BASHRC}

echo "== Installing .vimrc"
VIMRC="${HOME}/.vimrc"
cp ${VIMRC} "${VIMRC}.bak" >/dev/null 2>&1
rm ${VIMRC} >/dev/null 2>&1
ln -s "${SETUP_DIR}/vimrc" ${VIMRC}

echo "== Done"
