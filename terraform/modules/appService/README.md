# App Service Module

## Purpose
Deploys the application hosting layer for the solution, including:
- A shared App Service Plan (Linux)
- Backend App Service (Node/Express API)
- Frontend App Service (static site served by Nginx)
- VNet integration for the backend
- ACR pull permissions via managed identity
- Diagnostics settings

## Resources Created
- `azurerm_service_plan` (Linux B1)
- `azurerm_linux_web_app` (frontend & backend)
- `azurerm_role_assignment` (AcrPull for both apps)
- Diagnostics settings (via diagnostics module)

## Notes
- Backend App Service is VNet-integrated using `virtual_network_subnet_id` so it can reach the SQL Private Endpoint.
- Both apps pull their container images from ACR using managed identity.
- Backend injects database connection string; frontend injects backend API URL.
- Each app receives its own diagnostic settings.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_group_name` | string | Resource group name. |
| `location` | string | Azure region. |
| `plan_name` | string | App Service Plan name. |
| `frontend_app_name` | string | Frontend App Service name. |
| `backend_app_name` | string | Backend App Service name. |
| `frontend_image_name` | string | Container image (frontend). |
| `backend_image_name` | string | Container image (backend). |
| `acr_login_server` | string | ACR login server. |
| `acr_id` | string | ACR resource ID (for AcrPull role). |
| `sql_connection_string` | string | Connection string for backend. |
| `subnet_id` | string | Subnet for VNet integration (backend only). |
| `log_analytics_workspace_id` | any | Workspace for diagnostics. |
| `log_categories` | list(string) | Diagnostics log categories. |
| `metric_categories` | list(string) | Diagnostics metric categories. |
| `tags` | map(string) | Common tags. |

## Outputs

| Name | Description |
|------|-------------|
| `frontend_url` | Frontend default hostname. |
| `backend_url` | Backend default hostname. |

## Example Usage

```hcl
module "appService" {
  source = "../../modules/appService"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  log_analytics_workspace_id = module.logAnalytics.workspace_id

  plan_name         = var.plan_name
  frontend_app_name = var.frontend_app_name
  backend_app_name  = var.backend_app_name

  frontend_image_name = var.frontend_image_name
  backend_image_name  = var.backend_image_name
  acr_login_server    = module.acr.login_server
  acr_id              = module.acr.id

  log_categories    = var.appservice_log_categories
  metric_categories = var.appservice_metric_categories

  subnet_id = module.network.subnet_ids["subnet-backend-dev"]

  sql_connection_string = module.sql.sql_connection_string

  tags = var.tags
}
