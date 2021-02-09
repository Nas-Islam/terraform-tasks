variable "location" {}
variable "resource_group_name" {}
variable "vmss_subnet_id" {}
variable "vm_size" {}
variable "environment" {}
variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
  default     = "azureuser"
}
variable "admin_password" {}
variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)

  default = {
    environment = "vmss"
  }
}
variable "fdqn" {}