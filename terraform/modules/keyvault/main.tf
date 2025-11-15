resource "azurerm_key_vault" "kv" {
  name = var.key_vault_name
  location = var.location
  resource_group_name = var.resource_group_name
  tenant_id = var.tenant_id
  sku_name = "standard"
  purge_protection_enabled = true
  soft_delete_retention_days = 7
  
  tags = var.tags 
}

# resource "azurerm_key_vault_access_policy" "current_user" {
#   key_vault_id = azurerm_key_vault.kv.id
#   tenant_id = var.tenant_id
#   object_id = var.current_user_object_id

#   secret_permissions = [
#     "Get", "List", "Set"
#   ]
  
# }

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
