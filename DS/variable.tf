variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  type = string
}

variable "vpc" {
  default = {
    "ap-south-1" = "vpc-03f5f86284d6bd9bb"
    "ap-south-2" = "vpc-07bee84ef1deede82"
  }
}

variable "ingress_ports" {
  type = map(tuple([string, number, string]))
  default = {
    "ssh"   = ["14.194.163.180/32", 22, "tcp"]
    "http"  = ["0.0.0.0/0", 80, "http"]
    "https" = ["14.194.163.180/32", 443, "https"]
  }
}
