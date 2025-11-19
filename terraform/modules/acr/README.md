# ACR Module

## Purpose
Creates an Azure Container Registry (ACR) used to store and serve container images.  
Designed for App Services that authenticate using system-assigned managed identities and the `AcrPull` role.

## Resources Created
- `azurerm_container_registry` (Basic SKU, admin disabled)

## Notes
- Admin account is **disabled** for security; use managed identities instead.
- ACR name must be globally unique.
- Basic SKU does **not** support private endpoints.
- Typically used directly with App Service role assignments for secure image pulls.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `acr_name` | string | Globally unique registry name. |
| `resource_group_name` | string | Resource group where ACR is created. |
| `location` | string | Azure region. |
| `tags` | map(string) | Common resource tags. |

## Outputs

| Name | Description |
|------|-------------|
| `login_server` | ACR login server (`<name>.azurecr.io`). |
| `id` | ACR resource ID (used for role assignments). |
| `name` | ACR name. |

## Example Usage

```hcl
module "acr" {
  source              = "../../modules/acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_name            = var.acr_name
  tags                = var.tags
}
