variable "cnt" {
  type = number
}

variable "ami" {
  type    = string
  default = "ami-0024b53e5fc2f4fad"
}
variable "instance_type" {
  type    = string
  default = "t2.nano"
}

variable "availability_zones" {
  type = list
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c", "ap-south-2a", "ap-south-2b", "ap-south-2c"]
}
