// Output the VM IPs and admin user
output "public_vm_ip" {
    value = azurerm_linux_virtual_machine.public.public_ip_address
}

output "private_vm_ip" {
    value = azurerm_linux_virtual_machine.private.private_ip_address
}

output "admin_user" {
    value = azurerm_linux_virtual_machine.public.admin_username
}