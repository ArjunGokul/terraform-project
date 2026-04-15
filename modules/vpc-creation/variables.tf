variable "region" {
  type = string
}

variable "availability_zones" {
  type = map(any)
  default = {
    "ap-south-1" = ["ap-south-1a", "ap-south-1b", "ap-south-1c"],
    "ap-south-2" = ["ap-south-2a", "ap-south-2b", "ap-south-2c"]
  }
}
variable "cidr_block" {
  type = string
}

variable "cnt" {
  type = number
}
