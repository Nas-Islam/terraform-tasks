// Terraform configuration
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

// Provider
provider "azurerm" {
  features {}
}

// Resource Group
resource "azurerm_resource_group" "main" {
  name = "${var.project_name}-rg"
  location = var.location
}

// Virtual Network module
module "virtual_network" {
  source = "./vnet"
  // variables passed down to child modules here
  rgrp = azurerm_resource_group.main.name
  location = var.location
  project_name = var.project_name
}

// Virtual Machines module
module "virtual_machine" {
  source = "./vm"
  // variables passed down to child modules here
  rgrp = azurerm_resource_group.main.name
  location = var.location
  project_name = var.project_name
  user_name = var.user_name
  public_subnet_id = module.virtual_network.public_subnet_id
  private_subnet_id = module.virtual_network.private_subnet_id
}
