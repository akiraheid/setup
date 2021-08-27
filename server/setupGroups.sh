set -e

# Add users to the groups with usermod
#   usermod -a -G group username

echo "Creating music group"
addgroup music

if [ -d /raid/music ]; then
	echo "Changing group of /raid/music"
	chgrp -cRv music /raid/music
fi

echo "Creating movies group"
addgroup movies

if [ -d /raid/movies ]; then
	echo "Changing group of /raid/movies"
	chgrp -cRv movies /raid/movies
fi
