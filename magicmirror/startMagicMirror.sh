set -e
cd repos/MagicMirror
(git pull origin master; nodemon -x npm start)
