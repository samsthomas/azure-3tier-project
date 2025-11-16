output "workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "workspace_primary_key" {
    value = azurerm_log_analytics_workspace.law.primary_shared_key
    sensitive = true
  
}

output "workspace_location" {
  value = azurerm_log_analytics_workspace.law.location
}