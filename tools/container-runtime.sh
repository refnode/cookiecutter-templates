#!/bin/sh

#CONTAINER_IMAGE=$(yq e '.image' .gitlab/ci/init.yml)
CONTAINER_IMAGE=debian:buster-slim
PROJECT_NAME=$(basename $(pwd))
WORKSPACE_DIR="/workspaces/${PROJECT_NAME}"
ENV_FILE="$(pwd)/.env"

if ! test -f "${ENV_FILE}"
then
  touch "${ENV_FILE}"
fi

docker run -ti --rm \
  -v "$(pwd):${WORKSPACE_DIR}" \
  -w "${WORKSPACE_DIR}" \
  --env-file "${ENV_FILE}" \
  "${CONTAINER_IMAGE}" \
  /bin/bash
