#!/usr/bin/env bash
# Functions to be sourced by .bashrc to be used.

# Create a directory and change into it.
#
# This file must be sourced in your .bashrc as follows:
#    . /path/to/mkcd
#
# USAGE
#   mkcd dirname
#
# dirname The name of the directory to create and change into.
function mkcd {
	mkdir -p "$1" && (cd "$1" || return)
}

# Change directories quicker.
#
# This file must be sourced in .bashrc instead of being called like a regular
# executable to avoid executing in a subshell and leaving the original shell
# unaffected.
#
#    . /path/to/ud
#
# USAGE
#   ud [number]
#
# number  The number of directories to move up. If no number is given, it
#         moves up one directory.
function ud {
	if [[ $1 -eq 0 ]]; then
		cd .. || return
	else
		NUM=$1
		while [[ $NUM -ne 0 ]]; do
			cd .. || return
			NUM=$((NUM-1))
		done
	fi
}
