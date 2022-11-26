set -ex

found=`grep CHANGEME deployment.yaml`
if [ -n "$found" ]; then
	echo "Change default values before starting NextCloud"
	echo "$found"
	exit 1
fi

NAME=nextcloud-pod-0
podman pod exists $NAME && podman pod rm -f $NAME

# Start the pod, updating images, if available
podman play kube deployment.yaml

# Clean up old images
podman image prune -f
