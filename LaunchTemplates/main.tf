locals {
  tags = {
    Project = "Terraform-POC"
    Owner   = "Arjun"
  }
}

data "aws_ami" "fetch-ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["ubuntu-*24.04*-amd64*"]
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

data "aws_vpcs" "list-vpcs" {}

resource "aws_security_group" "private-sg" {
  tags = merge(local.tags, {
    Name = "private-sg"
  })
  vpc_id = data.aws_vpcs.list-vpcs.ids[0]
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

resource "aws_launch_template" "my-demo-launch-template" {
  name          = "ec2-free-tier-lt"
  instance_type = "t2.micro"
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }
  image_id               = data.aws_ami.fetch-ami.id
  key_name               = aws_key_pair.my-keypair.key_name
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  user_data              = filebase64("install-nginx.sh")
}

/*resource "aws_instance" "launch-from-lt" { 
  launch_template   { 
  id = aws_launch_template.my-demo-launch-template.id 
  version = "$Latest"
  }
}*/


data "aws_availability_zones" "list" {

}

data "aws_availability_zone" "fetch-az" {
  for_each = toset(data.aws_availability_zones.list.names)
  name     = each.value
}

resource "aws_autoscaling_group" "bar" {
  name                      = "terraform-asg-example"
  min_size                  = 0
  max_size                  = 2
  desired_capacity          = 0
  health_check_grace_period = "300"
  launch_template {
    id      = aws_launch_template.my-demo-launch-template.id
    version = "$Latest"
  }
  availability_zones = data.aws_availability_zones.list.names
  lifecycle {
    create_before_destroy = true
  }
}

output "availability_zones" {
  value = data.aws_availability_zone.fetch-az
}

output "vpc-id" {
  value = data.aws_vpcs.list-vpcs
}
