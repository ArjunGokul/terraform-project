variable "cnt" {
  type = number
}

variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}

variable "region" {
  type = string
}

variable "availability_zones" {
  type    = map
  default = {
   "ap-south-1" = ["ap-south-1a", "ap-south-1b", "ap-south-1c"],
   "ap-south-2" = ["ap-south-2a", "ap-south-2b", "ap-south-2c"],
  }
}
variable "os_disk_volume_type" {
  type = string
  default = "gp3"
}

variable "os_disk_size" {
  type = number
}

variable "data-disks" {
 type = number
}
variable "vpc_id" {
}

variable "ingress_ports" {
  type = list
  default = [22, 80, 8080, 443]
}


variable "subnet_ids" {
  type = list(string)
}
