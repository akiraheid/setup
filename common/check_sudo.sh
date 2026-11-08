#!/usr/bin/env bash
# Function for defining if `sudo` is necessary.
#
# Example usage:
#
# ```bash
#   check_sudo
#   $sudo command
# ```

set -e

check_sudo() {
	sudo=
	if [[ "$UID" != 0 ]]; then
		sudo=sudo
	fi
}
