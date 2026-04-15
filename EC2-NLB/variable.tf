variable "region" {
  type    = string
  default = ""
}

variable "store-key-details" {
  type = map(string)
  default = {
    "my-private-key" = "private_key_openssh"
    "my-public-key"  = "public_key_openssh"
  }
}
variable "ingress_ports" {
  type = map(tuple([string, number, string]))
  default = {
    "ssh"   = ["14.194.163.180/32", 22, "tcp"]
    "http"  = ["14.194.163.180/32", 80, "http"]
    "https" = ["14.194.163.180/32", 443, "https"]
  }
}
variable "instance_type" {
  type = string
}
