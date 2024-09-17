# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Put stuff here for stuff that applies to your whole session, such as programs
# that you want to start when you log in (but not graphical programs, they go
# into a different file), and environment variable definitions.
# https://superuser.com/a/183980

PATH=/usr/local/bin:/usr/bin:/bin

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Set PATH so it includes user's private bin
mkdir -p "$HOME/.local/bin"
PATH="$HOME/.local/bin:$PATH"

# Remove duplicates
TMP_PATH=$(echo "$PATH" | awk -v RS=":" -v ORS=":" '!a[$1]++{if (NR>1) printf ORS; printf $a[$1]}')

export PATH=$TMP_PATH
