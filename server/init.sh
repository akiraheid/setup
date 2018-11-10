#!/bin/bash
# Script to run on first start of a server

# Update the system
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove

# Install basic tools
sudo apt-get -y install git curl vim
