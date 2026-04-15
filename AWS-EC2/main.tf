resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "private_key_file" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "/home/nasg0725/Devops/Terraform/myprivate.key"
  file_permission = "0400"
}

resource "local_file" "public_key_file" {
  content  = tls_private_key.my_key.public_key_openssh
  filename = "/home/nasg0725/Devops/Terraform/mypublic.pem"
}

resource "aws_key_pair" "my-keypair" {
  key_name   = "my-keypair"
  public_key = tls_private_key.my_key.public_key_openssh
}
data "aws_vpc" "my-vpc" {}

resource "aws_eip" "my-public-ip" {
  domain = "vpc"
  count  = var.is_create ? var.cnt : 0
}

data "aws_ami" "ami-fetch" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["*ubuntu-*24.04*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "my-instance" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ami-fetch.id
  count         = var.is_create ? var.cnt : 0
  key_name      = aws_key_pair.my-keypair.key_name
  user_data     = file("install-nginx.sh")
  #provisioner "remote-exec" {
  #  inline = ["sudo apt-get update -y",
  #    "sudo apt-get install nginx -y",
  #    "sudo systemctl enable nginx",
  #    "sudo systemctl start nginx"
  #  ]
  #}
  #connection {
  #  type        = "ssh"
  #  host        = self.public_ip
  #  user        = "ubuntu"
  #  private_key = file("/home/nasg0725/Devops/Terraform/myprivate.key")
  #}
  vpc_security_group_ids = [aws_security_group.common_access.id]
  depends_on = [
    tls_private_key.my_key
  ]
  provisioner "local-exec" {
    command = "echo ${self.public_ip}"
  }

}

resource "aws_eip_association" "eip_assoc" {
  count         = var.is_create ? var.cnt : 0
  instance_id   = aws_instance.my-instance[count.index].id
  allocation_id = aws_eip.my-public-ip[count.index].id
}

resource "aws_security_group" "common_access" {
  name        = "common-sg"
  description = "Common SG access"
  vpc_id      = data.aws_vpc.my-vpc.id
  dynamic "ingress" {
    for_each = var.ingress_ports
    iterator = port
    content {
      from_port   = port.value[1]
      to_port     = port.value[1]
      protocol    = "tcp"
      cidr_blocks = [port.value[0]]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # "-1" allows all protocols
  }
}

output "aws_instance" {
  value = var.is_create ? aws_instance.my-instance[0].id : null
}

output "aws_instance_public_ip" {
  value = var.is_create ? aws_instance.my-instance[0].public_ip : null
}
output "aws_ami_id" {
  value = data.aws_ami.ami-fetch.id
}
