# Router Orchestrator Mainnet Service Setup

## Overview

This document provides instructions for setting up the Router Orchestrator Mainnet Service using Docker Swarm.

## Prerequisites

- Docker installed on your machine.
- Access to the private keys required for the service.

## Initialization

### Docker Swarm Initialization

Initialize Docker Swarm:

```bash
docker swarm init
```

### Setting Up Secrets

Store your Cosmos and Ethereum private keys as Docker secrets:

```bash
echo <COSMOS_PRIVATE_KEY> | docker secret create COSMOS_PRIVATE_KEY -
echo <ETH_PRIVATE_KEY> | docker secret create ETH_PRIVATE_KEY -
```

Replace `<COSMOS_PRIVATE_KEY>` and `<ETH_PRIVATE_KEY>` with your actual private keys.

## Service Creation

Create the `router_orchestrator_mainnet_service`:

```bash
docker service create
--name router_orchestrator_mainnet_service
--restart-condition on-failure
--restart-delay 10s
--secret source=ETH_PRIVATE_KEY,target=ETH_PRIVATE_KEY
--secret source=COSMOS_PRIVATE_KEY,target=COSMOS_PRIVATE_KEY
--mount type=bind,source=/Users/ganesh/repos/dfyn/router-chain/router-orchestrator/config.json,target=/router/config.json,readonly
--entrypoint "router-orchestrator start --config /router/config.json"
-p 8001:8001
--env-file .env
router_orchestrator_image
```

## Service Management

### Listing Services

To list all running services:

```bash
docker service ls
```

### Service Status

Check the status of the `router_orchestrator_mainnet_service`:

```bash
docker service ps router_orchestrator_mainnet_service
```

### Viewing Logs

To view the logs of the service:

```bash
docker service logs router_orchestrator_mainnet_service
```

### Removing the Service

To remove the service:

```bash
docker service rm router_orchestrator_mainnet_service
```

## Additional Notes

- Ensure that the file paths and environment variables are correctly set according to your system configuration.
- Handle private keys securely and avoid exposing them in unsecured locations.
