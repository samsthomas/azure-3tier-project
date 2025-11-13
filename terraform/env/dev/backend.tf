terraform {
  backend "azurerm" {
    resource_group_name  = "rg-3tier-dev"
    storage_account_name = "st3tierdevyw01jg"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"

  }
}