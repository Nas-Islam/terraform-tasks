terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name = "${var.project_name}-rg"
  location = var.location
}


// Virtual Network
resource "azurerm_virtual_network" "main" {
  name = "${var.project_name}-VNet"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = azurerm_resource_group.main.name
}

// Subnet
resource "azurerm_subnet" "main" {
    name                 = "${var.project_name}-Subnet"
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes       = ["10.0.1.0/24"]
}

// Public IP
resource "azurerm_public_ip" "main" {
    name                         = "${var.project_name}-PublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.main.name
    allocation_method            = "Dynamic"
}

// Network Security Group
resource "azurerm_network_security_group" "main" {
    name                = "${var.project_name}-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.main.name

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


// Network Interface
resource "azurerm_network_interface" "main" {
    name                      = "${var.project_name}-nic"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.main.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.main.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.main.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.main.id
    network_security_group_id = azurerm_network_security_group.main.id
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}


// Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
    name                  = "${var.project_name}-vm"
    location              = var.location
    resource_group_name   = azurerm_resource_group.main.name
    network_interface_ids = [azurerm_network_interface.main.id]
    size                  = var.vm_size

    os_disk {
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "${var.project_name}-vm"
    admin_username = var.user_name
    disable_password_authentication = true

    admin_ssh_key {
        username       = var.user_name
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

}