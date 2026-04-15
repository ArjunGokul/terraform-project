module "vpc-creation" {
  source     = "../../modules/vpc-creation/"
  cnt        = 1
  region     = "ap-south-1"
  cidr_block = "10.200.0.0/16"
}
