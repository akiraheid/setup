set -e

# Add users to the groups with usermod
#   usermod -a -G group username

echo "Creating books group"
addgroup books

if [ -d /raid/books ]; then
	echo "Changing group of /raid/books"
	chgrp -cRv books /raid/books
fi

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

echo "Creating podcasts group"
addgroup podcasts

if [ -d /raid/podcasts ]; then
	echo "Changing group of /raid/podcasts"
	chgrp -cRv podcasts /raid/podcasts
fi
