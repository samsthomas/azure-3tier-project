resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]


  dynamic "delegation" {
    for_each = each.key == "subnet-backend-app-dev" ? [1] : []
    content {
      name = "delegation-to-appservice"

      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_network_security_group" "nsgs" {
  for_each = var.create_nsgs ? var.subnets : {}

  name                = replace(each.key, "subnet", "nsg")
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "rules" {
  for_each = azurerm_network_security_group.nsgs

  name                        = "allow-basic-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.key == "subnet-db-dev" ? "1433" : "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = each.value.name


}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = azurerm_network_security_group.nsgs

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value.id

}