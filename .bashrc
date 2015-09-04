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
NORM="$(tput sgr 0)"
BLUE="$(tput setaf 62)"
CYAN="$(tput setaf 65)"
GREEN="$(tput setaf 83)"
RED="$(tput setaf 196)"
WHITE="$(tput setaf 253)"

USERNAME_COLOR=${GREEN}
AT_COLOR=${RED}
HOST_COLOR=${BLUE}
CUR_DIR_COLOR=${RED}

# Version control logic
GIT_BRANCH="git rev-parse --abbrev-ref HEAD 2>/dev/null"
INFO=${GIT_BRANCH}
INFO_COLOR=${GREEN}

if [[ `date +%m%d` == 0704 ]]; then # Fourth of July
  USERNAME=${RED}
  AT=${WHITE}
  HOST=${CYAN}
  CUR_DIR=${CYAN}
  INFO_COLOR=${RED}
elif [[ `date +%m%d` == 1225 ]]; then # Christmas
  USERNAME=${GREEN}
  AT=${WHITE}
  HOST=${RED}
  CUR_DIR=${GREEN}
  INFO_COLOR=${RED}
fi

export PS1="\[${USERNAME_COLOR}\]\u\[${AT_COLOR}\]@\[${HOST_COLOR}\]\h \[${WHITE}\][\[${CUR_DIR_COLOR}\]\w\[${WHITE}\]] (\[${INFO_COLOR}\]\`${INFO}\`\[${WHITE}\])\n\[${NORM}\]> "



# Functions

# Make a directory and change into it
function mkcd
{
  mkdir -p $1
  cd $1
}
