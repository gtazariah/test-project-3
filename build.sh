#!/bin/bash

set -e

DOCKERHUB_USERNAME="azariahgt"

ENVIRONMENT=$1

IMAGE_TAG=$2

if [ -z "$ENVIRONMENT" ] || [ -z "$IMAGE_TAG"  ]; then
	echo "Usage ./buid.sh <dev/prod> <tag>";
	exit 1
fi

if [ "$ENVIRONMENT" != "dev" ] && [ "$ENVIRONMENT" != "prod" ]; then
	echo "invlaid environment";
	exit 1
fi

IMAGE_NAME="${DOCKERHUB_USERNAME}/${ENVIRONMENT}"

FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

docker build \
	-t "${FULL_IMAGE_NAME}" \
	.
docker push "${FULL_IMAGE_NAME}"

