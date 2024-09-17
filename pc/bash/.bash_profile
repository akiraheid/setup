# Bash-specific environment to load when starting the computer session (login
# shell)

# Load ~/.profile, then load ~/.bashrc if running interactively
# https://superuser.com/a/183980
if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac
