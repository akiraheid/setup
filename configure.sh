#!/bin/bash

# Perform dev-system set up
# Set for helperFuncs.sh
DATE=`date +%Y%m%d-%H%M%S`

REPO_DIR="${HOME}/repos"
SETUP_DIR="${REPO_DIR}/setup"
VIM_BUNDLE_DIR="${HOME}/.vim/bundle"

# Update system and install base tools
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade\
	&& sudo apt-get -y autoremove

if [ -z `which dialog` ]; then
	sudo apt-get -y install dialog
fi

cmd=(dialog --separate-output --checklist "Select packages to install:" 22 76 16)
options=(1 "bashrc" off
	2 "keepassxc" off
	3 "pathogen" off
	4 "podman" off
	5 "syntastic" off
	6 "tmux" off
	7 "vim" off
	)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

# Exit if cancel or none selected
if [ ${#choices[@]} == "0" ]; then
	echo "Nothing selected. Goodbye."
	exit 0
fi

# Clone the setup repo
if [ -z `which  git` ]; then
	echo "Git not installed. Installing Git"
	sudo apt-get -y install git
fi

echo "Cloning setup repo"
mkdir -p $REPO_DIR
git clone --depth 1 https://github.com/akiraheid/setup.git ${SETUP_DIR} > /dev/null 2>&1
echo "Done"

. ${SETUP_DIR}/bash/helperFuncs.sh

for choice in $choices; do
	case $choice in
		1)
			(. ${SETUP_DIR}/bash/installbashrc.sh)
			;;
		2)
			(. ${SETUP_DIR}/bash/installkeepassxc.sh)
			;;
		3)
			(. ${SETUP_DIR}/bash/installpathogen.sh)
			INSTALLED_PATHOGEN=$?
			;;
		4)
			_install podman
			;;
		5)
			(. ${SETUP_DIR}/bash/installsyntastic.sh)
			;;
		6)
			(. ${SETUP_DIR}/bash/installtmux.sh)
			;;
		7)
			(. ${SETUP_DIR}/bash/installvim.sh)
			INSTALLED_VIM=$?
			;;
	esac
done

# Install make
_install build-essential
