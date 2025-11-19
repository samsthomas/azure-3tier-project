# Network Module

## Purpose
Creates the core virtual network for the solution, including subnets and optional NSGs.  
Designed to support a three-tier application structure (frontend, backend, database/private endpoint).

## What It Deploys
- **Virtual Network (VNet)**  
  Provisioned with a configurable address space.

- **Subnets** (dynamic from a map)  
  Each subnet receives its own address prefix.  
  One subnet (`subnet-backend-dev`) receives an **App Service delegation** so the backend App Service can integrate with it.

- **Network Security Groups (optional)**  
  If enabled, an NSG is created per subnet with simple inbound rules:
  - Backend subnet: port 443 allowed  
  - Private endpoint subnet: port 1433 allowed

- **NSG associations** linking each subnet to its respective NSG.

## Notes
- Only the *backend* subnet should be delegated to `Microsoft.Web/serverFarms` for App Service VNet Integration.
- The *database/private endpoint* subnet must **not** be delegated.
- The module exposes subnet IDs and prefixes for use by App Service and Private Endpoint modules.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `resource_group_name` | string | Resource group for the VNet. |
| `location` | string | Azure region. |
| `vnet_name` | string | Name of the VNet. |
| `address_space` | list(string) | VNet CIDR(s). |
| `subnets` | map(object) | Map of subnet names → CIDR prefixes. |
| `create_nsgs` | bool | Whether to create NSGs per subnet. |
| `tags` | map(string) | Resource tags. |

## Outputs

| Name | Description |
|------|-------------|
| `vnet_id` | ID of the VNet. |
| `nsg_ids` | Map of subnet → NSG IDs. |
| `subnet_ids` | Map of subnet → subnet IDs. |
| `subnet_prefix` | Map of subnet → CIDR prefix. |

## Example Usage

```hcl
module "network" {
  source = "../../modules/network"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  vnet_name     = var.vnet_name
  address_space = var.add_

  subnets = var.subnets

  tags = var.tags
}