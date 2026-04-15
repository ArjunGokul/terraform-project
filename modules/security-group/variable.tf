variable "region" {
  type = string
}

variable "ingress_ports" {
  type    = list(any)
  default = [22, 80, 8080, 443]
}
