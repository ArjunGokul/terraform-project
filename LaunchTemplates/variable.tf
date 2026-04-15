variable "region" {
  type    = string
  default = "ap-south-1"
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
    "ssh"   = ["192.140.152.164/32", 22, "tcp"]
    "http"  = ["192.140.152.164/32", 80, "http"]
    "https" = ["192.140.152.164/32", 443, "https"]
  }
}
