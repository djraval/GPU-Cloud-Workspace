#!/bin/bash -ex

# Source the .env file if it exists
if [ -f "./.env" ]; then
    source ./.env
else
    echo "Error: .env file not found."
    exit  1
fi

# Check if TAILSCALE_AUTHKEY is set, otherwise exit with an error message
if [ -z "$TAILSCALE_AUTHKEY" ]; then
    echo "Error: TAILSCALE_AUTHKEY environment variable is not set."
    exit  1
fi

IMAGE_NAME=gpu-workspace
BUILD_DIR=$(pwd)

# Get the container name or ID of the running container and remove it
CONTAINER_ID=$(docker ps -aqf "ancestor=$IMAGE_NAME")
if [ -n "$CONTAINER_ID" ]; then
    docker stop $CONTAINER_ID
    docker rm $CONTAINER_ID
fi

# Build the image and run the container
docker build -t $IMAGE_NAME "$BUILD_DIR"
docker run --privileged -d -e TAILSCALE_AUTHKEY=$TAILSCALE_AUTHKEY $IMAGE_NAME
