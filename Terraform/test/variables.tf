variable "ami" {
  type      = string
  sensitive = true
  validation {
    condition     = can(regex("^ami-", var.ami))
    error_message = "Invalid AMI ID. The value must start with 'ami-'. Example: ami-0a123456789abcd"
  }
}

variable "instance_type" {
  type = string
}
variable "server_name" {
  default = {
    "server1" = "nginx-1",
    "server2" = "nginx-2",
    "server3" = "nginx-3"
  }
}
