# Backend API

The backend is a Node.js Express API designed to sit in the middle tier of the solution.  
It exposes API endpoints to return messages, check health, and interact with the SQL database.

## Overview

The backend handles:

- HTTP requests from the frontend.
- Database queries (read/write).
- Secure access to Azure SQL via a Private Endpoint.
- CORS configuration to allow only the frontend domain.

## Key Features
- Runs inside an Azure App Service (Linux) via Docker.
- Integrated with the VNet using subnet `subnet-backend-dev`.
- Connects to Azure SQL using a private DNS zone + private endpoint.
- Uses system-assigned managed identity for ACR pulls.

## Main Endpoints
| Endpoint | Purpose |
|----------|---------|
| `GET /health` | Basic health check |
| `GET /api/message` | Returns message + DB config status |
| `GET /api/dbinit` | Creates table and inserts test row |
| `GET /api/dbrows` | Returns last 10 DB rows |

## Configuration
Environment variables injected via Terraform:

| Variable | Description |
|---------|-------------|
| `DB_CONNECTION_STRING` | Full SQL connection string |
| `FRONTEND_HOSTNAME` | Used for CORS |
| `ENVIRONMENT` | Defines environment (dev) |

## Deployment
The backend image is produced in GitHub Actions:

ACR_NAME.azurecr.io/backend:latest


The App Service applies the updated container config and restarts after deployment