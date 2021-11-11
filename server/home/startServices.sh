set -e

podman pod exists services && podman pod rm -f services

# Start the pod, updating images, if available
podman play kube services.yaml

# Clean up old images
podman image prune -f
