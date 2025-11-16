terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

module "network" {
  source = "../../modules/network"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  vnet_name     = var.vnet_name
  address_space = var.address_space

  subnets = var.subnets

  tags = var.tags

}

module "sql" {
  source = "../../modules/sql"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  sql_server_name            = var.sql_server_name
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  database_name              = var.database_name
  log_analytics_workspace_id = module.logAnalytics.workspace_id

  app_subnet_prefix = var.subnets["subnet-app-dev"].address_prefix

  tags = var.tags

}

module "appService" {
  source = "../../modules/appService"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  log_analytics_workspace_id = module.logAnalytics.workspace_id

  plan_name         = var.plan_name
  frontend_app_name = var.frontend_app_name
  backend_app_name  = var.backend_app_name

  subnet_id = module.network.subnet_ids["subnet-app-dev"]

  sql_connection_string = module.sql.sql_connection_string

  tags = var.tags

}

module "storage" {
  source = "../../modules/storage"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  storage_account_name       = "st3tierdev${random_string.suffix.result}"
  log_analytics_workspace_id = module.logAnalytics.workspace_id
  tags                       = var.tags

}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = module.storage.storage_account_id
  container_access_type = "private"
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

module "keyvault" {
  source = "../../modules/keyvault"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  key_vault_name             = var.key_vault_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  current_user_object_id     = data.azurerm_client_config.current.object_id
  sql_admin_password         = var.admin_password
  github_oidc_object_id      = var.github_oidc_object_id
  log_analytics_workspace_id = module.logAnalytics.workspace_id
  tags                       = var.tags

}

data "azurerm_client_config" "current" {}

module "logAnalytics" {
  source = "../../modules/logAnalytics"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  workspace_name      = var.workspace_name
  tags                = var.tags
}

module "appInsights" {
  source = "../../modules/appInsights"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  workspace_id               = module.logAnalytics.workspace_id
  log_analytics_workspace_id = module.logAnalytics.workspace_id

  app_insights = {
    frontend = {
      name = var.frontend_app_insights_name
    }

    backend = {
      name = var.backend_app_insights_name
    }
  }

  tags = var.tags
}
