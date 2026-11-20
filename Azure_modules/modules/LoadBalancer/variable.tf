variable "lb_name" {
  type        = string
  description = "Name of the load balancer."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

variable "network_interface_ids" {
  type        = map(string)
  description = "Map of NIC name => NIC ID to add to the backend pool."
}

variable "ip_configuration_name" {
  type        = string
  description = "Name of the ip_configuration block on the NICs."
  default     = "internal"
}

variable "frontend_port" {
  type        = number
  description = "Port the load balancer listens on."
  default     = 80
}

variable "backend_port" {
  type        = number
  description = "Port on the VMs that traffic is forwarded to."
  default     = 80
}

variable "probe_path" {
  type        = string
  description = "HTTP path used by the health probe."
  default     = "/"
}

variable "ssh_frontend_port_start" {
  type        = number
  description = "First LB frontend port used for SSH NAT rules (one port per VM)."
  default     = 50001
}
