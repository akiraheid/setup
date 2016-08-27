#!/bin/bash

# Perform dev-system set up.

echo "== Updating"
yes | apt-get update

echo "== Upgrading"
yes | apt-get upgrade

echo "== Dist-upgrading"
yes | apt-get dist-upgrade

echo "== Installing dev packages"
yes | apt-get install clang cmake cppcheck curl git vim

echo "== Autoremove"
yes | apt-get autoremove

echo "== Checking for pathogen..."
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  echo "==== Pathogen not found. Installing"
  mkdir -p ~/.vim/autoload ~/.vim/bundle
  curl https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -o ~/.vim/autoload/pathogen.vim
else
  echo "==== Pathogen already installed"
fi
