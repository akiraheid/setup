if [ -r ~/.profile ]; then
	. ~/.profile
fi

case "$-" in *i*)
	if [ -r ~/.bashrc ]; then
		. ~/.bashrc
		syncthing
	fi
esac
