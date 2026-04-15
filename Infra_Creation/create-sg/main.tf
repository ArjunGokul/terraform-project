provider "aws" {
  region = "us-east-1"
  alias  = "usa"
}

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}


module "sg" {
  source = "../../modules/sg-creation"
  providers = {
    aws.mumbai = aws.mumbai
    aws.usa    = aws.usa
  }
}

resource "aws_eip" "my-eip" {
  domain   = "vpc"
  provider = aws.usa
}
