module "vpc-creation" {
  source = "../../modules/vpc-creation/"
  cnt = 3
  region = "ap-south-2"
  cidr_block = "10.204.0.0/16"
}
