variable "region" {
  type = string
}
variable "store-key-details" {
  type = map(string)
  default = {
    "my-private-key" = "private_key_openssh"
    "my-public-key"  = "public_key_openssh"
  }
}
