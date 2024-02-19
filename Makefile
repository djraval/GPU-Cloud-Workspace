# Makefile

include .env

# Variables
DOCKER_HUB_USERNAME := djraval
DOCKER_HUB_REPOSITORY := gpu-cloud-workspace
TAG := latest
IMAGE_NAME := gpu-workspace
BUILD_DIR := $(PWD)
CONTAINER_NAME := remote-workspace-container



# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Push the Docker image to Docker Hub
push:
	@docker login -u $(DOCKER_HUB_USERNAME) -p $(DOCKER_HUB_PASSWORD)
	docker tag $(IMAGE_NAME) $(DOCKER_HUB_USERNAME)/$(DOCKER_HUB_REPOSITORY):$(TAG)
	docker push $(DOCKER_HUB_USERNAME)/$(DOCKER_HUB_REPOSITORY):$(TAG)

# Deploy to vast.ai (placeholder for actual deployment command)
deploy:
	@echo "Deploying to vast.ai..."
	# Here, you would include the command to deploy to vast.ai

# Define a task for setting up and running the project, including building the image and deploying
setup-and-deploy: build push deploy

.PHONY: build push deploy setup-and-deploy
