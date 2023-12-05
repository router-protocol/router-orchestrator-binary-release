#!/bin/bash

echo "1. Checking if Docker is installed..."

if ! command -v docker &>/dev/null; then
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt install docker-ce -y
    sudo systemctl status docker
    USER=$(whoami)
    sudo usermod -aG docker "${USER}"
    sudo systemctl start docker
    sudo su - "${USER}"
    echo "Docker installed successfully"
    docker swarm init
    echo "Docker version: $(docker --version)"
else
    echo "Docker is already installed."
    docker swarm init
fi

echo "2. Building Docker image"

SCRIPT_PATH=$(readlink -f "$0")
DIRECTORY_PATH=$(dirname "$SCRIPT_PATH")
echo "$DIRECTORY_PATH"

docker build \
    --no-cache \
    -t router_orchestrator_image:latest \
    -f "${DIRECTORY_PATH}"/Dockerfile .

# check if image was built successfully
if [ $? -eq 0 ]; then
    echo "Docker image built successfully"
else
    echo "Docker image build failed"
    exit 1
fi