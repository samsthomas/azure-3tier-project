output "endpoint_hostname" {
  value = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}

output "profile_id" {
  value = azurerm_cdn_frontdoor_profile.fd_profile.id
}