#!/bin/bash

# Perform dev-system set up.

echo "== Updating"
yes | apt-get update

echo "== Upgrading"
yes | apt-get upgrade

echo "== Installing dev packages"
yes | apt-get install clang cmake cppcheck curl git vim nodejs

echo "== Autoremove"
yes | apt-get autoremove

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
