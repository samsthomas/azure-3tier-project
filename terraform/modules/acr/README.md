# Module: appService

Manages the frontend and backend App Services, including:
- Docker container configuration
- Managed identity integration
- Private VNet integration
- ACR pull permissions

## Architecture Notes
This module integrates only the backend app into the VNet subnet `subnet-backend-dev`.  
The frontend remains public because it is fronted by Azure Front Door.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |

## Example Usage
```hcl
module "appService" {
  source = "../modules/appService"

  backend_app_name   = "api-3tier-dev"
  frontend_app_name  = "web-3tier-dev"
  subnet_id          = module.network.subnet_backend_id
  sql_connection_string = module.sql.connection_string
}

## The backend app needs VNet integration to reach the SQL Private Endpoint.
## The frontend app remains public for Azure Front Door routing.