resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  rbac_authorization_enabled = false

  tags = var.tags
}


resource "azurerm_key_vault_access_policy" "github_oidc" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = var.tenant_id
  object_id = var.github_oidc_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]

}

module "diagnostics_kv" {
  source = "../../modules/diagnostics"

  resource_name              = azurerm_key_vault.kv.name
  resource_id                = azurerm_key_vault.kv.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories    = var.log_categories
  metric_categories = var.metric_categories

}