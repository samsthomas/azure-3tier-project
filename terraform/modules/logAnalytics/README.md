# Log Analytics Workspace Module

## Purpose
Creates a Log Analytics Workspace used as the central logging and monitoring backend for the solution.  
Other modules (App Service, SQL, Key Vault, Front Door, App Insights, Storage, etc.) send diagnostics to this workspace.

## Resources Created
- `azurerm_log_analytics_workspace`

## Notes
- Workspace SKU is set to `PerGB2018`, which is cost-effective and supports all monitoring features.
- Retention is configured for **30 days**, suitable for dev/test environments.
- The workspace ID and keys are output for use by dependent modules (App Insights, diagnostics, etc.).

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_group_name` | string | Resource group for the workspace. |
| `location` | string | Azure region. |
| `workspace_name` | string | Name of the Log Analytics workspace. |
| `tags` | map(string) | Resource tags. |

## Outputs

| Name | Description |
|------|-------------|
| `workspace_id` | The resource ID of the workspace. |
| `workspace_name` | The name of_
