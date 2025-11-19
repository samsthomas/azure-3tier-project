# Storage Module

## Purpose
Deploys a general-purpose Azure Storage Account for application storage needs, with optional diagnostic logging.

## What It Deploys
- **Storage Account** (Standard/LRS, TLS 1.2, public access enabled)
- **Diagnostic Settings** forwarding logs and metrics to Log Analytics

## Notes
- Public network access is currently enabled for simplicity.
- Diagnostic settings are optional and based on provided category lists.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_group_name` | string | Resource group for the storage account. |
| `location` | string | Azure region. |
| `storage_account_name` | string | Name of the storage account. |
| `log_analytics_workspace_id` | string | Workspace for diagnostic logs. |
| `log_categories` | list(string) | Storage log categories. |
| `metric_categories` | list(string) | Storage metric categories. |
| `tags` | map(string) | Resource tags. |

## Outputs

| Name | Description |
|------|-------------|
| `storage_account_id` | ID of the storage account. |
| `storage_account_name` | Name of the account. |
| `primary_key` | Primary access key (sensitive). |
| `primary_connection_string` | Primary connection string (sensitive). |

## Example Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  storage_account_name       = "st3tierdev${random_string.suffix.result}"
  log_analytics_workspace_id = module.logAnalytics.workspace_id

  log_categories    = var.storage_log_categories
  metric_categories = var.storage_metric_categories

  tags = var.tags
}
