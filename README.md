# azure-3tier-project

# PART 1 — BASIC 3-TIER ARCHITECTURE (NO PRIVATE ENDPOINTS)

Resource Group: rg-3tier-dev

## NETWORKING
- vnet-3tier-dev (10.0.0.0/16)
- Subnets:
  - subnet-web-dev (10.0.1.0/24)
  - subnet-app-dev (10.0.2.0/24)
  - subnet-db-dev  (10.0.3.0/24)
- NSGs: one per subnet with light rules:
  - web-subnet: allow inbound from Front Door
  - app-subnet: allow inbound from web-subnet
  - db-subnet: allow inbound 1433 from app-subnet

## INGRESS
- Azure Front Door (Standard)
  - Sends traffic → frontend app
  - Origin: frontend app public URL (simple for now)
  - No private origin lock yet

## FRONTEND TIER
- App Service Plan (asp-3tier-dev)
- Frontend App Service: app-frontend-dev
- VNet Integration → subnet-web-dev
- Environment variables for backend URL

## BACKEND TIER
- Backend App Service: app-backend-dev
- VNet Integration → subnet-app-dev
- Managed Identity optional in Part 1
- Talks to SQL via public FQDN

## DATABASE TIER
- SQL Server: sqlsrv-3tier-dev
- SQL DB: sqldb-3tier-dev
- Public access enabled (restricted)
  - Allow Azure services
  - Allow your IP (for testing)

## MONITORING
- Application Insights (appi-3tier-dev)
- Log Analytics Workspace (law-3tier-dev)

## TRAFFIC FLOW
User → Front Door → Frontend App → Backend API → SQL (public endpoint)

# Notes:
- Everything public now → much easier for testing
- Part 2 will swap SQL & KV to private endpoints
- Architecture is intentionally simple but clean
