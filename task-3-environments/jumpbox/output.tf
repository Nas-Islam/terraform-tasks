output "jumpbox_public_ip" {
   value = azurerm_public_ip.jumpbox.fqdn
}

output "admin_user" {
    value = var.admin_user
}