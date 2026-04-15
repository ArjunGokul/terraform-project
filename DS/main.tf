locals {
  common_tags = {
    Project     = "Terraform"
    Owner       = "Nagarjuna"
    Description = "Terraform"
  }
}


resource "tls_private_key" "create-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private-key" {
  filename        = "/home/nasg0725/Devops/Terraform/DS/myprivate.key"
  content         = tls_private_key.create-key.private_key_pem
  file_permission = 400
}

data "aws_ec2_instance_type" "fetch" {
  instance_type = var.instance_type
}

data "aws_ami" "example" {
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

data "aws_vpc" "default-vpc" {
  #id = var.vpc[var.region]
  default = true
}

resource "aws_key_pair" "my-keypair" {
  key_name   = tls_private_key.create-key.id
  public_key = tls_private_key.create-key.public_key_openssh
  tags = merge(local.common_tags, {
    Name = "my-ec2-key-pair"
  })
}

resource "aws_instance" "check" {
  ami           = data.aws_ami.example.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.my-keypair.key_name
  #user_data     = file("./install-nginx.sh")
  lifecycle {
    precondition {
      condition     = data.aws_ec2_instance_type.fetch.free_tier_eligible
      error_message = "Given instance_type is not eligible for free tier, please provide valid instance_type"
    }
    postcondition {
      condition     = self.public_ip != ""
      error_message = "No public ip found for this ec2-instance"
    }
  }
  provisioner "local-exec" {
    command = "sleep 150"
  }
  provisioner "remote-exec" {
    inline = ["sudo apt-get install nginx -y",
    "sudo systemctl start nginx"]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/nasg0725/Devops/Terraform/DS/myprivate.key")
    host        = self.public_ip
  }
  vpc_security_group_ids = [aws_security_group.security-group.id]
  depends_on             = [aws_security_group.security-group, tls_private_key.create-key]
  tags = merge(local.common_tags, {
    Name = "my-ec2-vm"
  })
}

resource "aws_security_group" "security-group" {
  name        = "allow-fewports"
  description = "allow-fewports"
  vpc_id      = data.aws_vpc.default-vpc.id
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
  tags = merge(local.common_tags, {
    Name = "my-sg"
  })
}


output "ami-id" {
  value = data.aws_ami.example.id
}

output "free_tier_eliible" {
  value = data.aws_ec2_instance_type.fetch.free_tier_eligible
}
