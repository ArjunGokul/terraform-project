resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "private_key_file" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "~/myprivate.key"
  file_permission = "0400"
}

resource "local_file" "public_key_file" {
  content  = tls_private_key.my_key.public_key_openssh
  filename = "~/mypublic.pem"
}

resource "aws_key_pair" "my-keypair" {
  key_name   = "my-keypair"
  public_key = tls_private_key.my_key.public_key_openssh
}
data "aws_vpc" "default-vpc" {
  id = "vpc-0ce30347b3cd6bab8"
}

data "aws_ami" "my-ami" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-[0-9]{3}"
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu-*-24.04-*-amd64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "nginx-server" {
  instance_type = var.instance_type
  key_name = aws_key_pair.my-keypair.key_name
  count = var.is_create ? var.cnt : 0
  ami = data.aws_ami.my-ami.id
  tags = {
   Name = "nginx-server-01"
  }
}
