# Application Insights Module

## Purpose
Deploys one or more Azure Application Insights instances and links each to Log Analytics for centralised diagnostics.  
Useful for collecting telemetry from frontend and backend App Services.

## Resources Created
- `azurerm_application_insights` (workspace-based, type: `web`)
- Diagnostics settings applied via the `diagnostics` module

## Notes
- Uses **for_each** to deploy multiple App Insights instances (e.g., frontend & backend).
- Requires an existing Log Analytics Workspace (`workspace_id`).
- Connection strings are typically injected into App Service app settings.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_group_name` | string | Resource group for the resources. |
| `location` | string | Azure region. |
| `workspace_id` | string | Log Analytics workspace ID for workspace-based AI. |
| `log_analytics_workspace_id` | any | Workspace ID used for diagnostics settings. |
| `app_insights` | map(object) | Map of AI instances to deploy (`name` required). |
| `log_categories` | list(string) | Diagnostic log categories. |
| `metric_categories` | list(string) | Diagnostic metric categories. |
| `tags` | map(string) | Common resource tags. |

## Outputs

| Name | Description |
|------|-------------|
| `instrumentation_keys` | Map of AI instrumentation keys per instance. |
| `connection_string` | Map of AI connection strings per instance. |

## Example Usage

```hcl
module "appInsights" {
  source                    = "../../modules/appInsights"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  workspace_id              = module.logAnalytics.workspace_id
  log_analytics_workspace_id = module.logAnalytics.workspace_id
  log_categories            = var.appinsights_log_categories
  metric_categories         = var.appinsights_metric_categories

  app_insights = {
    frontend = { name = var.frontend_app_insights_name }
    backend  = { name = var.backend_app_insights_name }
  }

  tags = var.tags
}
