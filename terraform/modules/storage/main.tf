resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = true

  tags = var.tags

}

module "diagnostics_storage" {
  source = "../../modules/diagnostics"

  resource_name              = azurerm_storage_account.sa.name
  resource_id                = azurerm_storage_account.sa.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories    = var.storage_log_categories
  metric_categories = var.storage_metric_categories

}