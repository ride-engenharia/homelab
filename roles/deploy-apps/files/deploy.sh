#!/bin/bash

# Configuration
REPO_DIR="/ridelab-data/deploy-apps/$1"
REGISTRY="localhost:5000"
IMAGE_NAME="$1"

# 1. Update code or clone
if [ -d "$REPO_DIR/.git" ]; then
    echo "Updating existing repository in $REPO_DIR..."
    cd "$REPO_DIR"
    git pull origin main
else
    echo "Cloning repository from git@github.com:ride-engenharia/"$1".git into $REPO_DIR..."
    git clone git@github.com:ride-engenharia/"$1".git "$REPO_DIR"
    cd "$REPO_DIR"
fi

TAG=$(git rev-parse --short HEAD)

echo "Building image $IMAGE_NAME:$TAG..."
podman build -t $IMAGE_NAME:$TAG -f Dockerfile.production

echo "Tagging image $IMAGE_NAME:$TAG..."
podman tag $IMAGE_NAME:$TAG $REGISTRY/$IMAGE_NAME:$TAG
podman tag $IMAGE_NAME:$TAG $REGISTRY/$IMAGE_NAME:latest

echo "Pushing image $IMAGE_NAME:$TAG..."
podman push $REGISTRY/$IMAGE_NAME:$TAG
podman push $REGISTRY/$IMAGE_NAME:latest

echo "Restarting container $IMAGE_NAME..."
systemctl --user restart $IMAGE_NAME.service

echo "Done!"
