variable "environment" {}
variable "location" {}
variable "resource_group_name" {}
variable "admin_password" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vmss" {
    source = "../../vmss"
    environment = var.environment
    location = var.location
    admin_password = var.admin_password
    resource_group_name = var.resource_group_name
}

output "vmss_public_ip" {
  value = module.vmss.vmss_public_ip
}