# SQL Module

## Purpose
Deploys a secure Azure SQL setup using **private access only**, with no public exposure.  
Designed so backend services in a delegated subnet can connect privately through a Private Endpoint and DNS zone.

## What It Deploys
- **Azure SQL Server** (public networking disabled)
- **Azure SQL Database**
- **Private DNS Zone** for `privatelink.database.windows.net`
- **VNet Link** connecting the DNS zone to the application VNet
- **Private Endpoint** in the designated subnet, providing a private IP for SQL
- **Diagnostic Settings** sent to Log Analytics

## Notes
- Public network is fully disabled for SQL.
- SQL is accessible only from the VNet via the Private Endpoint.
- The backend App Service must be VNet-integrated into a subnet **different** from the Private Endpoint subnet.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_group_name` | string | Resource group for SQL resources. |
| `location` | string | Azure region. |
| `sql_server_name` | string | Name of the SQL server. |
| `database_name` | string | Name of the SQL database. |
| `admin_username` | string | SQL admin username. |
| `admin_password` | string | SQL admin password. |
| `private_endpoint_subnet_id` | string | Subnet ID used for the SQL Private Endpoint. |
| `vnet_id` | string | VNet ID for Private DNS linking. |
| `log_analytics_workspace_id` | string | LA workspace for diagnostics. |
| `log_categories` | list(string) | Diagnostic log categories. |
| `metric_categories` | list(string) | Diagnostic metric categories. |
| `tags` | map(string) | Resource tags. |

## Outputs

| Name | Description |
|------|-------------|
| `sql_server_name` | SQL server name. |
| `sql_database_name` | SQL DB name. |
| `sql_connection_string` | Full SQL connection string (private endpoint resolved via DNS). |

## Example Usage

```hcl
module "sql" {
  source = "../../modules/sql"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  sql_server_name            = var.sql_server_name
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  database_name              = var.database_name

  log_analytics_workspace_id = module.logAnalytics.workspace_id
  log_categories             = var.sql_log_categories
  metric_categories          = var.sql_metric_categories

  private_endpoint_subnet_id = module.network.subnet_ids["subnet-db-pe-dev"]
  vnet_id                    = module.network.vnet_id

  tags = var.tags
}
