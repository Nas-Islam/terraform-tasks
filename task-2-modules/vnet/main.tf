// Virtual Network
resource "azurerm_virtual_network" "main" {
  name = "${var.project_name}-VNet"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = var.rgrp
}

// Public Subnet with NSG allowing SSH from everywhere
resource "azurerm_subnet" "public" {
    name                 = "${var.project_name}-public-subnet"
    resource_group_name  = var.rgrp
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes       = ["10.0.1.0/24"]
}


resource "azurerm_network_security_group" "public" {
    name                = "${var.project_name}-public-nsg"
    location            = var.location
    resource_group_name = var.rgrp

    security_rule {
        name                       = "allowSSH"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}


// Private Subnet with NSG allowing SSH from public subnet
resource "azurerm_subnet" "private" {
    name                 = "${var.project_name}-private-subnet"
    resource_group_name  = var.rgrp
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes       = ["10.0.2.0/24"]
}



resource "azurerm_network_security_group" "private" {
    name                = "${var.project_name}-private-nsg"
    location            = var.location
    resource_group_name = var.rgrp

    security_rule {
        name                       = "allowSSH"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "10.0.1.0/24"
        destination_address_prefix = "10.0.1.0/24"
    }
}
