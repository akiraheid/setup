#!/bin/bash
# Git repository: https://github.com/ggml-org/llama.vim
# llama.vim does not have releases yet. A local copy is kept in the `vim/`
# versioned off the git commit hash until release versions are created.
set -e

# Set up variables and directories
function setup() {
	# Define constants
	THIS_DIR=$(dirname "$(readlink -f "$0")")
	readonly THIS_DIR

	BUNDLE_DIR=${VIM_BUNDLE_DIR:-"${HOME}/.vim/bundle"}
	readonly BUNDLE_DIR

	# Load libraries
	. "${THIS_DIR}/logging"

	# Prepare directories
	mkdir -p "${BUNDLE_DIR}"
}

# Install llama.vim
function install() {
	info "Installing vim plugin: llama.vim"
	local version
	version=20250703-f886bad

	cp -r "${THIS_DIR}/../vim/llama.vim-${version}" "${BUNDLE_DIR}/"
}

{
	setup
	install
}
