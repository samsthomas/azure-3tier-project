# Front Door Module

## Purpose
Creates an Azure Front Door (Standard) profile, endpoint, origin group, origin, and route to expose an App Service application globally with caching, TLS, and routing controls.

## Resources Created
- `azurerm_cdn_frontdoor_profile`
- `azurerm_cdn_frontdoor_endpoint`
- `azurerm_cdn_frontdoor_origin_group` (frontend and backend)
- `azurerm_cdn_frontdoor_origin` (frontend and backend)
- `azurerm_cdn_frontdoor_route` (frontend and backend)

## Notes
- Fronts both the frontend (`/*`) and backend API (`/api/*`) App Services.
- Backend traffic is routed to a dedicated origin group.
- Enforces HTTPS redirection and uses HTTPS-only forwarding.
- Origin host headers are set to the respective App Service default hostnames.
- No custom domains configured here; those can be added separately if needed.

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `name` | string | Base name used for all Front Door resources. |
| `resource_group_name` | string | Resource group for deployment. |
| `app_service_default_hostname` | string | Default hostname of the frontend app (origin). |
| `backend_default_hostname` | string | Default hostname of the backend app (origin for `/api/*`). |
| `tags` | map(string) | Tags applied to all resources. |

## Outputs

| Name | Description |
|------|-------------|
| `endpoint_hostname` | Public hostname of the Front Door endpoint. |
| `profile_id` | Front Door profile ID. |

## Example Usage

```hcl
module "frontdoor" {
  source = "../../modules/frontdoor"

  name                         = "3tier-dev"
  resource_group_name          = azurerm_resource_group.rg.name
  app_service_default_hostname = module.appService.frontend_default_hostname
  backend_default_hostname     = module.appService.backend_url
  tags = var.tags
}
