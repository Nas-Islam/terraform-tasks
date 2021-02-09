// Public IP
resource "azurerm_public_ip" "public" {
    name                         = "${var.project_name}-PublicIP"
    location                     = var.location
    resource_group_name          = var.rgrp
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface" "public" {
  name                = "${var.project_name}-public-nic"
  location            = var.location
  resource_group_name = var.rgrp

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}

// Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "public" {
    name                  = "${var.project_name}-public-vm"
    location              = var.location
    resource_group_name   = var.rgrp
    network_interface_ids = [
        azurerm_network_interface.public.id
    ]
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

    computer_name  = "${var.project_name}-public-vm"
    admin_username = var.user_name
    disable_password_authentication = true

    admin_ssh_key {
        username       = var.user_name
        public_key     = file("~/.ssh/id_rsa.pub")
    }

}

// Private VM
resource "azurerm_network_interface" "private" {
  name                = "${var.project_name}-private-nic"
  location            = var.location
  resource_group_name = var.rgrp

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "private" {
    name                  = "${var.project_name}-private-vm"
    location              = var.location
    resource_group_name   = var.rgrp
    network_interface_ids = [
        azurerm_network_interface.private.id
    ]
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

    computer_name  = "${var.project_name}-private-vm"
    admin_username = var.user_name
    disable_password_authentication = true

    admin_ssh_key {
        username       = var.user_name
        public_key     = file("~/.ssh/id_rsa.pub")
    }

}
