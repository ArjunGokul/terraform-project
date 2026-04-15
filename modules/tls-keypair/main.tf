locals {
   tags = {
    Project = "Terraform"
    Owner = "Nagarjuna SG"
   }
}
resource "tls_private_key" "my-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "public-key" {
  for_each = var.store-key-details
  content  = tls_private_key.my-key[each.value]
  filename = "/home/nasg0725/Devops/Terraform/EC2-ALB/${each.key}.pem"
}

resource "aws_key_pair" "my-keypair" {
  key_name   = tls_private_key.my-key.id
  public_key = tls_private_key.my-key.public_key_openssh
  tags = merge(local.tags, {
    Name = "Tls-Key Pair"
  })
}

output "aws_keypair_name" {
  value = aws_key_pair.my-keypair.key_name 
}
