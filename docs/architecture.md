# Architecture Overview

## High-Level 3-Tier Architecture

```mermaid

flowchart LR

    A[User Browser] --> B[Azure Front Door]

    B --> C[Frontend App Service]

    C --> D[Backend App Service]

    D --> E[SQL Private Endpoint]

    E --> F[Azure SQL Server]

    subgraph VNET
        subgraph SUBNET_BACKEND
            D
        end

        subgraph SUBNET_SQL_PE
            E
        end
    end

    subgraph ACR
        G[Frontend Image]
        H[Backend Image]
    end

    G --> C
    H --> D

    subgraph OBSERVABILITY
        I[Log Analytics Workspace]
        J[App Insights Frontend]
        K[App Insights Backend]
        L[Diagnostic Settings]
    end

    C --> J
    D --> K

    C --> L
    D --> L
    E --> L
    F --> L
    I --> L



```