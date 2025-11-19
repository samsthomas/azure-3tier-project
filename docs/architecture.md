# Architecture Overview

## High-Level 3-Tier Architecture

```mermaid

flowchart LR
    A[User Browser] --> B[Azure Front Door<br/>Public Endpoint]

    B --> C[Frontend App Service<br/>Container Image<br/>Public URL]

    C --> D[Backend App Service<br/>Container Image<br/>VNet Integrated<br/>Subnet: backend-dev]

    D -->|Private DNS Lookup<br/>privatelink.database.windows.net| E[Azure SQL Database<br/>Private Endpoint<br/>Subnet: db-pe-dev]

    subgraph VNET[VNet]
        C
        D
        E
    end

    subgraph ACR[Azure Container Registry (ACR)]
        F[Container Images<br/>frontend:latest<br/>backend:latest]
    end

    subgraph OBS[Observability]
        G[Log Analytics Workspace]
        H[App Insights - Frontend]
        I[App Insights - Backend]
        J[Diagnostic Settings]
    end

    C --> H
    D --> I
    C --> J
    D --> J
    E --> J


```