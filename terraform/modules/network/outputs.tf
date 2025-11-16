output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "nsg_ids" {
  description = "IDs of NSGs created per subnet"
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}

output "subnet_ids" {
  description = "ID's of the subnets created"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_prefix" {
  description = "CIDR prefixes of the subnets"
  value       = { for k, v in azurerm_subnet.subnets : k => v.address_prefixes[0] }

}