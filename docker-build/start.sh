#!/bin/bash
# usage: ./start.sh <path to config file> [health check port]
# default health check port is 8001

CONFIG_FILE_PATH=${1}
HEALTH_CHECK_PORT=${2:-8001}
SERVICE_NAME="router_orchestrator_mainnet_service"
IMAGE_NAME="router_orchestrator_image"

if ! docker image ls | grep -q "${IMAGE_NAME}"; then
    echo "Image ${IMAGE_NAME} does not exist. Please build it first."
    exit 1
fi

if [ -z "${CONFIG_FILE_PATH}" ]; then
    echo "Usage: ./start.sh <path to config file> [health check port]"
    exit 1
fi

if docker service ls | grep -q "${SERVICE_NAME}"; then
    echo "Service ${SERVICE_NAME} is already running. Do you want to remove the service? (y/n)"
    while true; do
        read -r -p "" yn
        case $yn in
        [Yy]*)
            docker service rm "${SERVICE_NAME}"
            break
            ;;
        [Nn]*) exit ;;
        *) echo "Please answer yes (y) or no (n)." ;;
        esac
    done
fi


echo "Starting router orchestrator with config file: ${CONFIG_FILE_PATH}."
echo "Health check port: ${HEALTH_CHECK_PORT}"

docker service create \
    --name ${SERVICE_NAME} \
    --restart-condition on-failure \
    --restart-delay 10s \
    --restart-max-attempts 5 \
    --secret source=ETH_PRIVATE_KEY,target=ETH_PRIVATE_KEY \
    --secret source=COSMOS_PRIVATE_KEY,target=COSMOS_PRIVATE_KEY \
    --mount type=bind,source="${CONFIG_FILE_PATH}",target=/router/config.json,readonly \
    --entrypoint "router-orchestrator start --config /router/config.json" \
    -p "${HEALTH_CHECK_PORT}":8001 \
    ${IMAGE_NAME}
