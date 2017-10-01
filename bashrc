#
# This file should be left in the repository and a symlink with the name
# ".bashrc" should be created in the user directory and point to this file.

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


# Setup repo scripts
SETUP_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}) )
. ${SETUP_DIR}/bash/ud
. ${SETUP_DIR}/bash/mkcd


# Default editor
EDITOR=vim

# Aliases
alias cp='cp -p'
alias gs='git status'
alias iba='ionic cordova build android'
alias iea='ionic cordova emulate android'
alias la='ls -aA'
alias ll='ls -lhA'
alias lR='ls -RF'
alias ls='ls -F'
alias sf='grep --line-number --recursive --directories=recurse'
alias sff='grep --files-with-matches --recursive --directories=recurse'
alias topme="top -u `whoami`"
alias u='ud'
alias v='vim'


# Update PATH
if [ -f ${HOME}/.path ]; then
  while read -r line
  do
    PATH="${PATH}:$line"
  done < ${HOME}/.path
fi

# Remove duplicates
PATH=$(echo "$PATH" | awk -v RS=":" -v ORS=":" '!a[$1]++{if (NR>1) printf ORS; printf $a[$1]}')

export PATH=$PATH


# Terminal coloring (assuming 256 colors)
TERM=xterm-256color
NORM="$(tput sgr 0)"
BLUE="$(tput setaf 62)"
CYAN="$(tput setaf 65)"
GREEN="$(tput setaf 83)"
ORANGE="$(tput setaf 220)"
RED="$(tput setaf 196)"
WHITE="$(tput setaf 253)"

USERNAME_COLOR=${GREEN}
AT_COLOR=${RED}
HOST_COLOR=${BLUE}
CUR_DIR_COLOR=${RED}
VC_TYPE_COLOR=${ORANGE}
VC_INFO_COLOR=${RED}

# Version control logic
function getGitBranch {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function getInfo {
  DELIM="|"
  VC_INFO="`getGitBranch`"
  if [ "$VC_INFO" ]; then
    VC_TYPE="Git"
  else
    DELIM=""
    VC_INFO=""
    VC_TYPE=""
  fi
  echo "(\[${VC_INFO_COLOR}\]${VC_INFO}\[${WHITE}\])\n"
}

function updatePS1 {
  if [[ `date +%m%d` == 0704 ]]; then # Fourth of July
    USERNAME=${RED}
    AT=${WHITE}
    HOST=${CYAN}
    CUR_DIR=${CYAN}
    VC_COLOR=${RED}
  elif [[ `date +%m%d` == 1225 ]]; then # Christmas
    USERNAME=${GREEN}
    AT=${WHITE}
    HOST=${RED}
    CUR_DIR=${GREEN}
    VC_COLOR=${RED}
  fi

  export PS1="\[${USERNAME_COLOR}\]\u\[${AT_COLOR}\]@\[${HOST_COLOR}\]\h \[${WHITE}\][\[${CUR_DIR_COLOR}\]\w\[${WHITE}\]] `getInfo`\[${NORM}\]> "
}

PROMPT_COMMAND="updatePS1"

updatePS1
