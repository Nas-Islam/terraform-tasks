// Outputs that you want to display after you run terraform apply
output "public_vm_ip" {
    value = module.virtual_machine.public_vm_ip
}

output "private_vm_ip" {
    value = module.virtual_machine.private_vm_ip
}

output "admin_user" {
    value = module.virtual_machine.admin_user
}