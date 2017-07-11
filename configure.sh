#!/bin/bash

# Perform dev-system set up.

echo "== Updating"
apt-get -y update

echo "== Upgrading"
apt-get -y upgrade

echo "== Autoremove"
apt-get -y autoremove

echo "== Installing dev packages"
apt-get -y install clang cmake cppcheck curl git vim

echo "== Autoremove"
apt-get -y autoremove

echo "== Checking for pathogen..."
VIM_BUNDLE_DIR=~/.vim/bundle
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  echo "==== Pathogen not found. Installing"
  mkdir -p ~/.vim/autoload $VIM_BUNDLE_DIR
  curl https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -o ~/.vim/autoload/pathogen.vim
else
  echo "==== Pathogen already installed"
fi

echo "== Installing vim packages..."
if [ ! -d $VIM_BUNDLE_DIR/syntastic ]; then
  echo "==== Syntastic not found. Installing"
  git clone --depth=1 https://github.com/scrooloose/syntastic.git $VIM_BUNDLE_DIR/syntastic
fi

echo "== Done"
