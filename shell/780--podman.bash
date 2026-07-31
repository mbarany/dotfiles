# Point the docker CLI at podman's socket.
# Not needed once `sudo podman-mac-helper install` puts the socket at the default path.
PODMAN_API_SOCK="${TMPDIR}podman/podman-machine-default-api.sock"
[ -S "${PODMAN_API_SOCK}" ] && export DOCKER_HOST="unix://${PODMAN_API_SOCK}"
unset PODMAN_API_SOCK
