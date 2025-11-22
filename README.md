# 3-Tier Azure Infrastructure Project

This repository deploys a complete 3-tier application environment on Azure using Terraform.  
It follows a modular design, with reusable components for networking, compute, storage, observability and security.

The deployed architecture includes:

- Frontend App Service (container)
- Backend App Service (container)
- Azure SQL Database (private endpoint only)
- Azure Container Registry (ACR)
- Azure Front Door Standard (frontend + `/api` backend routing)
- Azure Key Vault
- Azure Storage Account
- Virtual Network with subnets for backend + SQL private endpoints
- Private DNS Zone for SQL
- Log Analytics Workspace + diagnostic settings
- Application Insights for frontend + backend

Each component is built as a dedicated Terraform module to keep the configuration clean and maintainable.

---

## Project Structure

```
terraform/
  env/
    dev/
      main.tf
      variables.tf
      terraform.tfvars

  modules/
    acr/
    appInsights/
    appService/
    diagnostics/
    frontdoor/
    keyvault/
    logAnalytics/
    network/
    sql/
    storage/
```

env/dev contains the environment-specific composition of modules. Which would hold more environments in a production environment but just has dev for now

modules/ contains the reusable infrastructure modules, each with its own README.

## How to Deploy

Prerequisites

Azure CLI installed and logged in:
```
az login
```

Set the correct subscription:
```
az account set --subscription "<subscription_id>"
```

Terraform installed (v1.5+ recommended).
Populate terraform.tfvars with your environment values.

Init / plan / apply
```
terraform init
terraform plan
terraform apply
```
This deploys the entire environment

# CI/CD Pipelines

This repository uses two distinct pipelines:

### Terraform Pipeline

- Validates, plans and applies changes.
- Uses GitHub OIDC for Azure authentication.
- Performs linting with tflint.

### Application Build & Deploy Pipeline

- Builds Docker images for backend and frontend.
- Pushes images to ACR.
- Deploys containers to App Service.
- Restarts apps to pick up new images.
- Infrastructure and application deployments remain cleanly separated.

## Environment Configuration

All environment-level settings live in:
terraform/env/dev/terraform.tfvars

Typical values include:
```
location      = "uksouth"
vnet_name     = "vnet-3tier-dev"
address_space = ["10.0.0.0/16"]

subnets = {
  subnet-backend-dev = { address_prefix = "10.0.2.0/24" }
  subnet-db-pe-dev   = { address_prefix = "10.0.3.0/24" }
}

admin_username = "sqladmin"
```
## How the Application Works

Once deployed:

Frontend App Service calls the backend using the configured API_URL.
Backend App Service communicates with SQL over:
VNet Integration
SQL private endpoint
Private DNS (privatelink.database.windows.net)

Frontend → Backend flows through the public URL (Front Door) with `/api/*` pinned to the backend origin.
Frontend builds its API_URL from the Front Door hostname and the backend CORS allowlist uses the same hostname.
Backend → SQL is fully private inside the VNet.
Backend exposes test endpoints such as:
/health
/api/message
/api/dbinit
/api/dbrows
These are useful for confirming 3-tier connectivity.

## Observability

This deployment includes:
Centralised Log Analytics Workspace
Diagnostic settings for all major services
Application Insights for frontend and backend
Logs, metrics, and telemetry flow to a single workspace for easy monitoring.

But there is still work to do to polish this area

## What would I do differently / what would I add

In the future I will look to use different network tools, enforce naming conventions and policies, add more environments / build out the application pipeline and look to lock down security as I know its not following all best practices across the board yet
