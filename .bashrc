# .bashrc

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize



# Custom setup stuff. Change this directory to wherever you clone the git repo to
SETUP_DIR=~/code/setup

# Up directory script
. ${SETUP_DIR}/bin/ud
alias u='ud'



# Aliases
alias cp='cp -p'
alias ls='ls -F --color=always'
alias ll='ls -lhA --color=always'
alias la='ls -ahA --color=always'



# Terminal coloring
tput setab 233
BLUE="$(tput setaf 62)"
GREEN="$(tput setaf 83)"
RED="$(tput setaf 196)"
WHITE="$(tput setaf 253)"
USERNAME=${GREEN}
AT=${RED}
HOST=${BLUE}
CUR_DIR=${RED}

export PS1="\[${USERNAME}\]\u\[${AT}\]@\[${HOST}\]\h \[${CUR_DIR}\]\w\n\[${WHITE}\]> "



# Functions

# Make a directory and change into it
function mkcd
{
  mkdir -p $1
  cd $1
}
