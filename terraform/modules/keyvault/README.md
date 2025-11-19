# Key Vault Module

## Purpose
Deploys an Azure Key Vault instance with access policies and diagnostic settings.  
This module is intentionally lightweight and currently under-utilised (no secrets are being stored yet), but it provides the foundation for future secure secret management.

## Resources Created
- `azurerm_key_vault`
- `azurerm_key_vault_access_policy` (GitHub OIDC identity)
- Diagnostic settings for logs and metrics

## Notes
- RBAC is **disabled**, so access is controlled using access policies.
- GitHub OIDC is granted `Get`, `List`, and `Set` secret permissions so CI/CD can read or write secrets if needed.
- No secrets are created in this module, but it is ready for future expansion.
- Diagnostic logs flow to Log Analytics for auditing and monitoring.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_group_name` | string | Resource group for the Key Vault. |
| `location` | string | Azure region. |
| `key_vault_name` | string | Name of the Key Vault. |
| `tenant_id` | string | Azure AD tenant ID. |
| `current_user_object_id` | string | Optional—current user ID if assigning additional access. |
| `sql_admin_password` | string | Not currently used, kept for potential future secret storage. |
| `github_oidc_object_id` | string | Object ID for GitHub OIDC federated identity. |
| `log_analytics_workspace_id` | string | Workspace for diagnostics. |
| `tags` | map(string) | Resource tags. |
| `log_categories` | list(string) | Diagnostic log categories. |
| `metric_categories` | list(string) | Diagnostic metric categories. |

## Outputs

| Name | Description |
|------|-------------|
| `key_vault_id` | The Key Vault resource ID. |
| `key_vault_uri` | The Vault URI used for secret access. |

## Example Usage

```hcl
module "keyvault" {
  source = "../../modules/keyvault"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  key_vault_name             = var.key_vault_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  current_user_object_id     = data.azurerm_client_config.current.object_id
  sql_admin_password         = var.admin_password
  github_oidc_object_id      = var.github_oidc_object_id
  log_analytics_workspace_id = module.logAnalytics.workspace_id

  tags = var.tags

  log_categories    = var.kv_log_categories
  metric_categories = var.kv_metric_categories
}

data "azurerm_client_config" "current" {}
```

