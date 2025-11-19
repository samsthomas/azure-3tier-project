# Architecture Overview

## High-Level 3-Tier Architecture

```mermaid

flowchart LR
    A[User Browser] --> B[Azure Front Door]

    B --> C[Frontend App Service]

    C --> D[Backend App Service<br/>VNet Integrated]

    D -->|Private DNS Lookup| E[Azure SQL Database<br/>Private Endpoint]

    subgraph VNET[VNet]
        C
        D
        E
    end

    subgraph ACR[Azure Container Registry (ACR)]
        F[Frontend Image]
        G[Backend Image]
    end

    subgraph OBS[Observability]
        H[Log Analytics Workspace]
        I[App Insights - Frontend]
        J[App Insights - Backend]
        K[Diagnostic Settings]
    end

    C --> I
    D --> J
    C --> K
    D --> K
    E --> K



```