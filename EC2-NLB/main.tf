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
    values = ["ubuntu-*24.04*-amd*"]
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

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.list-vpcs.ids
  }
}
data "aws_subnet" "subnet_info" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
}
resource "aws_security_group" "nlb-sg" {
  name   = "nlb-sg"
  vpc_id = data.aws_vpcs.list-vpcs.ids[0]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["14.194.163.180/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "private-sg" {
  tags = merge(local.tags, {
    Name = "private-sg"
  })
  vpc_id = data.aws_vpcs.list-vpcs.ids[0]
  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nlb-sg.id]
  }
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

resource "aws_instance" "my-ec2" {
  ami                    = data.aws_ami.fetch-ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my-keypair.key_name
  for_each               = data.aws_subnet.subnet_info
  subnet_id              = each.value.id
  user_data              = file("./install-nginx.sh")
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  tags = merge(local.tags, {
    Name = "my-instance-1${substr(each.value.availability_zone, -1, 1)}"
  })


}

resource "aws_lb" "demo-nlb" {
  name               = "demo-lb-tf"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.private-sg.id, aws_security_group.nlb-sg.id]
  subnets            = data.aws_subnets.example.ids[*]
  tags = merge(local.tags, {
    Name = "my-app-lb"
  })
}

resource "aws_lb_target_group" "demo-tg" {
  name     = "demo-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpcs.list-vpcs.ids[0]
  health_check {
    path = "/"
  }
  tags = merge(local.tags, {
    Name = "my-app-lb-target-group"
  })
}

resource "aws_lb_target_group_attachment" "attach-alb" {
  for_each         = aws_instance.my-ec2
  target_group_arn = aws_lb_target_group.demo-tg.arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb_listener" "front_end_listener" {
  load_balancer_arn = aws_lb.demo-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-tg.arn
  }
}

output "vpc-id" {
  value = data.aws_vpcs.list-vpcs.ids[*]
}

output "subnet-id" {
  value = data.aws_subnets.example.ids[*]
}

output "alb_dns" {
  value = aws_lb.demo-nlb.dns_name
}
