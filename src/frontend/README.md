# Frontend Application

The frontend is a lightweight static web UI built with HTML, JavaScript, and a simple build-less structure.  
It runs inside an Azure App Service (Linux) using a container image pushed to Azure Container Registry (ACR).

## Overview

The frontend is responsible for:

- Rendering the UI for the 3-tier demo.
- Calling the backend API using the `API_URL` environment variable injected by Terraform.
- Displaying backend API responses and database rows.

## Key Features
- Deployed as a Docker container to Azure App Service.
- No framework (React/Vue/etc.) for simplicity.
- Communicates with the backend over HTTPS only.
- CORS handled via backend configuration.

## Endpoints Used
- `GET /api/message` – General API status.
- `GET /api/dbrows` – Recent DB entries.

## Configuration
The app uses the following environment variable:

| Variable | Description |
|---------|-------------|
| `API_URL` | Fully qualified backend endpoint URL set by Terraform |

## Deployment
Container image is built in GitHub Actions and pushed to ACR:

ACR_NAME.azurecr.io/frontend:latest


The App Service pulls the updated image on deploy and restarts automatically.