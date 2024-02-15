#!/bin/bash -ex

# Docker Hub https://hub.docker.com/repository/docker/djraval/gpu-cloud-workspace/
DOCKER_HUB_USERNAME=djraval
DOCKER_HUB_REPOSITORY=gpu-cloud-workspace
TAG=latest

IMAGE_NAME=gpu-workspace
BUILD_DIR=$(pwd)

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

# Check if RCLONE_CONFIG_CONTENT is set, otherwise exit with an error message
if [ -z "$RCLONE_CONFIG_CONTENT" ]; then
    echo "Error: RCLONE_CONFIG_CONTENT environment variable is not set."
    exit  1
fi

# Get the container name or ID of the running container and remove it
CONTAINER_ID=$(docker ps -aqf "ancestor=$IMAGE_NAME")
if [ -n "$CONTAINER_ID" ]; then
    docker stop $CONTAINER_ID
    docker rm $CONTAINER_ID
fi

# Build the image and run the container and then view the logs
docker build -t $IMAGE_NAME "$BUILD_DIR"

# Tag the image and then push it to the Docker Hub
docker tag $IMAGE_NAME $DOCKER_HUB_USERNAME/$DOCKER_HUB_REPOSITORY:$TAG
docker push $DOCKER_HUB_USERNAME/$DOCKER_HUB_REPOSITORY:$TAG

# Construct the docker run command
DOCKER_RUN_CMD="docker run --privileged --gpus all -d -e TAILSCALE_AUTHKEY=$TAILSCALE_AUTHKEY -e RCLONE_CONFIG_CONTENT=\"$RCLONE_CONFIG_CONTENT\" $DOCKER_HUB_USERNAME/$DOCKER_HUB_REPOSITORY:$TAG"
echo "Running the container with the following command:"
echo $DOCKER_RUN_CMD

CONTAINER_ID=$(eval $DOCKER_RUN_CMD)
docker logs -f $CONTAINER_ID
