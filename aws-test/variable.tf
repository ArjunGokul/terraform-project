variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
}
variable "instance_name" {
  description = "The name of the instance"
  type        = set(string)
}

variable "volume_size" {
  description = "The size of the EBS volume in GB"
  type        = number
}

variable "ingress_ports" {
  description = "List of allowed TCP ingress ports"
  type        = list(number)
}