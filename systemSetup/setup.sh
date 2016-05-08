#!/bin/bash

# Perform dev-system set up.

yes | apt-get update
yes | apt-get upgrade
yes | apt-get dist-upgrade
yes | apt-get install clang cmake cppcheck curl git vim
yes | apt-get autoremove
