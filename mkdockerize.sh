#!/usr/bin/env bash

set -o errexit

CURRENT_SCRIPT="$(basename -- ${BASH_SOURCE[0]})"
CURRENT_DIRECTORY="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_BINARY="$(command -v docker)"
DOCKER_NAME="${DOCKER_NAME:-mkdockerize}"
MKDOCS_TARGET_DIRECTORY="/src/mkdocs"

# Bind mount arguments used for docker run.
# - https://docs.docker.com/storage/bind-mounts/#start-a-container-with-a-bind-mount
MOUNT_ARGS="--mount type=bind,source=${CURRENT_DIRECTORY},target=${MKDOCS_TARGET_DIRECTORY}"

PRODUCE_ARGS="${MOUNT_ARGS}"
SERVE_ARGS="-d -p 8000:8000 ${MOUNT_ARGS}"

function main() {
  local container_id=$(docker ps | grep mkdockerize | awk '{print $1}')

  if [ "${container_id}" != "" ]; then
    echo "[INFO] mkdockerize is currently running so we're stopping the process inside the container..."
    $DOCKER_BINARY stop $container_id
  fi

  $DOCKER_BINARY run $PRODUCE_ARGS $DOCKER_NAME produce
  $DOCKER_BINARY run $SERVE_ARGS $DOCKER_NAME serve
}

main
