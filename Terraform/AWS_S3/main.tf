resource "aws_s3_bucket" "s3-bucket" {
   bucket = local.bucket_name
   tags = {
    Project = "POC"
    Owner  = "Arjun"
   }

}

resource "aws_s3_object" "upload" {
  bucket = aws_s3_bucket.s3-bucket.bucket
  key = "provider.tf"
  source = "/home/nasg0725/Devops/Terraform/AWS_S3/provider.tf"
}

resource "random_string" "random-string" {
  length = 8
  upper = false
  special = false
}

locals {
   bucket_name = "${var.project}-${random_string.random-string.id}-bucket"
}
