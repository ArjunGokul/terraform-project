variable "admin_username" {
  type        = string
  description = "Admin username for the virtual machine."
}

variable "admin_password" {
  type        = string
  description = "Admin password for the virtual machine."
  sensitive   = true
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual machine."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group in which to create the virtual machine."
}

variable "vm_name" {
  type        = set(string)
  description = "The name of the virtual machine."
}

variable "os_disk_size" {
  type        = number
  description = "The size of the OS disk in GB."
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine."
}

variable "inbound_port" {
  type        = list(number)
  description = "The port number for the inbound rule."
  default     = [22, 80, 443]
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of VM names to subnet IDs."
}
