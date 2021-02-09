// Define empty variable blocks – values inherited from module blocks
variable "rgrp" {}
variable "location" {}
variable "project_name" {}
variable "user_name" {}
variable "vm_size" {
    default = "Standard_DS1_v2"
}
variable "public_subnet_id" {}
variable "private_subnet_id" {}