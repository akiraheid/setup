# bash alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# ls aliases
alias ll='ls -lhAF'
alias la='ls -AF'
alias l='ls -CF'

# enable color support of commands and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -F --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
	alias ls='ls -F'
fi

# git aliases
alias gf='git fetch'
alias gfrom='git fetch && git rebase origin/master'
alias gs='git status'

# grep aliases
alias sf='grep --line-number --recursive --directories=recurse'
alias sff='grep --files-with-matches --recursive --directories=recurse'

# protonvpn aliases
alias vpnd='protonvpn-cli d'
alias vpnf='protonvpn-cli c -f'
alias vpnr='protonvpn-cli c -r'

# other aliases
alias cp='cp -p'
alias topme="top -u `whoami`"
alias u='ud'
alias v='vim'
