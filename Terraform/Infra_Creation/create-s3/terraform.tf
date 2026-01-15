terraform {
  backend "s3" {
    bucket  = "arjun-s3-backend-bucket"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
}
