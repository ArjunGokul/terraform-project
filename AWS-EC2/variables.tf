variable "cnt" {
  type = number
}
variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

variable "availability_zones" {
  type    = list(any)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c", "ap-south-2a", "ap-south-2b", "ap-south-2c"]
}

variable "is_create" {
  type = bool
}

variable "ingress_ports" {
  type = map(tuple([string, number, string]))
  default = {
    "ssh"   = ["192.140.152.132/32", 22, "tcp"]
    "http"  = ["192.140.152.132/32", 80, "http"]
    "https" = ["192.140.152.132/32", 443, "https"]
    "tcp"   = ["192.140.152.132/32", 8080, "tcp"]
  }
}

