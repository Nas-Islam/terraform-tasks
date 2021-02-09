variable "environment" {}
variable "location" {}
variable "resource_group_name" {}
variable "admin_password" {}
variable "vm_size" {}

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

module "jumpbox" {
  source = "../../jumpbox"
  environment = var.environment
  location = var.location
  admin_password = var.admin_password
  resource_group_name = var.resource_group_name
  vm_size = var.vm_size
  fdqn = module.vmss.fdqn
  vmss_subnet_id = module.vmss.vmss_subnet_id
}

output "vmss_public_ip" {
  value = module.vmss.vmss_public_ip
}