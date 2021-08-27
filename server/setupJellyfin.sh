set -e

podman run \
	-d \
	--name jellyfin \
	-p 8096:8096 \
	--rm \
	-v /raid/music/:/media/music/:ro \
	-v /raid/movies/:/media/movies/:ro \
	-v jellyfin-cache:/cache \
	-v jellyfin-config:/config \
	jellyfin/jellyfin
