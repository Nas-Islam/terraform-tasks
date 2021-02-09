output "vmss_public_ip" {
  value = azurerm_public_ip.vmss.fqdn
}

output "fdqn" {
  value = random_string.fqdn.result
}

output "vmss_subnet_id" {
  value = azurerm_subnet.vmss.id
}