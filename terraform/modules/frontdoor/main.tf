resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "${var.name}-fd-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "${var.name}-fd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  enabled                  = true

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "${var.name}-og"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  session_affinity_enabled                                  = false
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 5

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                          = "${var.name}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  host_name          = var.app_service_default_hostname
  https_port         = 443
  origin_host_header = var.app_service_default_hostname

  enabled                        = true
  certificate_name_check_enabled = false

}

resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "${var.name}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.fd_origin.id
  ]

  https_redirect_enabled = true
  enabled                = true
  forwarding_protocol    = "HttpsOnly"
  supported_protocols    = ["Https"]

  patterns_to_match = ["/*"]

  link_to_default_domain = true

  #   origin_path = ""

  cache {
    query_string_caching_behavior = "IgnoreQueryString"
  }

}