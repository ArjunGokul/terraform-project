locals {
  common_tags = {
    Project     = "Terraform-POC"
    Owner       = "Nagarjuna SG"
    Description = "Terraform Basics"
  }
  bucket_name = "${var.project}-${random_string.suffix.id}"
}

resource "random_string" "suffix" {
  length = 8
  upper = false
  special = false
}
 
resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = local.bucket_name

  tags = merge(local.common_tags, {
    Name = local.bucket_name
  })
  depends_on = [random_string.suffix]
}

resource "aws_s3_bucket_policy" "my-bucket-policy" {
  policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForStaticWebsite",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.my-s3-bucket.id}/*"
    }
  ]
  }
  EOF
  bucket = aws_s3_bucket.my-s3-bucket.id
  count = var.static_website_enable ? 1 : 0
  depends_on = [ aws_s3_bucket_public_access_block.public_access ]
}


resource "aws_s3_object" "my-s3-bucket-object" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  key = "main.tf"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  count = var.static_website_enable ? 1 : 0
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static-website" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  count = var.static_website_enable ? 1 : 0
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

output "s3_bucket_id" {
  value = aws_s3_bucket.my-s3-bucket.id
}
