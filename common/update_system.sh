#!/usr/bin/env bash
# Update the system.

update_system() {
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt autoremove -y
}

{
	update_system
}
