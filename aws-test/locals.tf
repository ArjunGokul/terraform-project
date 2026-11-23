locals {
  common_tags = {
    Environment = "dev"
    Project     = "terraform-project"
    Owner       = "Arjun"
  }

  instance_map = {
    for idx, name in tolist(var.instance_name) : name => idx
  }

  device_names = [
    for i in range(11) :
    "/dev/sd${substr("fghijklmnop", i, 1)}"
  ]
}