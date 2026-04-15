variable "availability_zones" {
  default = {
    "ap-south-1" = ["ap-south-1a", "ap-south-1b", "ap-south-1c"],
    "ap-south-2" = ["ap-south-2a", "ap-south-2b", "ap-south-2c"],
    "us-east-1"  = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"],
  }
}
