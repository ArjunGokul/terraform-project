module "ec2-creation" {
  source = "../../modules/ec2-creation"
  cnt = 3
  ami = "ami-0024b53e5fc2f4fad"
  instance_type = "t2.micro"
  os_disk_size = 50
  os_disk_volume_type = "gp3" 
  region = "ap-south-2"
  data-disks = 40
  cidr_block = "10.204.0.0/16"
}
