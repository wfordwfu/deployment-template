terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
      }
    }
    backend "azurerm" {
      resource_group_name  = "${var.prefix}-${var.resource_group}"
      storage_account_name = "${var.prefix}-${var.storage_account}"
      container_name       = "${var.prefix}-${var.storage_container}"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.resource_group}"
  location = var.region
}

module "sa" {
  source = "./modules/storage_account"

  storage_account_name = "${var.prefix}-${var.storage_account}"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location

}

module "sc" {
  source = "./modules/storage_container"
  storage_container_name = "${var.prefix}-${var.storage_container}"
  storage_account_name = module.sa.sa_name
}

#terraform {
#  backend "azurerm" {
#    resource_group_name  = azurerm_resource_group.rg.name
#    storage_account_name = module.sa.sa_name
#    container_name       = module.sc.sc_name
#    key                  = "terraform.tfstate"
#  }
#}

