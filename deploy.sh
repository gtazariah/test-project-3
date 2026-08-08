#!/bin/bash

set -e

DOCKERHUB_USERNAME="azariahgt"

ENVIRONMENT=$1

IMAGE_TAG=${2:-latest}

CONTAINER_NAME="react-app"

HOST_PORT=5000

CONTAINER_PORT=80

if [ "$ENVIRONMENT" != "dev" ] && [ "$ENVIRONMENT" != "prod" ]; then
	exit 1
fi

IMAGE="${DOCKERHUB_USERNAME}/${ENVIRONMENT}:${IMAGE_TAG}"

docker pull "${IMAGE}"

# stop existing container

if docker ps -q \
	--filter "name=^/${CONTAINER_NAME}" \
	| grep -q .; then

	docker stop "${CONTAINER_NAME}"

fi

# remove existing container

if docker ps -aq \
	--filter "name=^/${CONTAINER_NAME}" \
	| grep -q .; then
	
	docker rm "${CONTAINER_NAME}"
fi

#start new container

docker run -d \
	--name "${CONTAINER_NAME}" \
	-p "${HOST_PORT}:${CONTAINER_PORT}" \
	--restart unless-stopped \
	"${IMAGE}"


