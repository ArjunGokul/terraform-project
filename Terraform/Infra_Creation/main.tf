module "vpc" {
  source     = "../modules/vpc-creation"
  cnt        = 1
  region     = "ap-south-1"
  cidr_block = "10.204.0.0/16"
}

module "ec2" {
  source              = "../modules/ec2-creation"
  cnt                 = 1
  ami                 = "ami-0024b53e5fc2f4fad"
  instance_type       = "t2.micro"
  os_disk_size        = 50
  os_disk_volume_type = "gp3"
  region              = "ap-south-1"
  data-disks          = 40

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

