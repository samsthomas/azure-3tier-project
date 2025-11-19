# Diagnostics Module

## Purpose
Creates a standardised Azure Monitor Diagnostic Setting for any resource.  
Used by other modules to enable logs and metrics collection in Log Analytics.

## Resources Created
- `azurerm_monitor_diagnostic_setting`

## Notes
- Works generically with any Azure resource ID.
- Allows passing specific log and metric categories depending on the resource type.
- Sends all logs/metrics to a specified Log Analytics Workspace.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_name` | any | Name of the resource (used for diagnostic setting name). |
| `resource_id` | any | Resource ID to attach diagnostic settings to. |
| `log_analytics_workspace_id` | any | Workspace receiving logs/metrics. |
| `log_categories` | list(string) | Log categories to enable. |
| `metric_categories` | list(string) | Metric categories to enable. |

## Outputs
None.

## Example Usage

```hcl
module "diagnostics_storage" {
  source = "../../modules/diagnostics"

  resource_name              = azurerm_storage_account.sa.name
  resource_id                = azurerm_storage_account.sa.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories    = var.log_categories
  metric_categories = var.metric_categories
}
