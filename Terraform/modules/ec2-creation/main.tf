locals {
  common_tags = {
    Project     = "Terraform-POC"
    Owner       = "Nagarjuna SG"
    Description = "Terraform Basics"
  }
}

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
  tags = merge(local.common_tags, {
    Name = "My Key-pair"
  })
}

data "aws_ami" "ubuntu_2404" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*",
      "ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "my-instance" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.ubuntu_2404.id 
  count                  = var.cnt
  key_name               = aws_key_pair.my-keypair.key_name
  user_data              = file("/home/nasg0725/Devops/Terraform/modules/ec2-creation/install-nginx.sh")
  vpc_security_group_ids = [aws_security_group.common_access.id]
  subnet_id              = var.subnet_ids[count.index]
  depends_on = [
    tls_private_key.my_key,
    aws_key_pair.my-keypair,
    local_file.private_key_file,
    local_file.public_key_file
  ]
  provisioner "local-exec" {
    on_failure = continue
    command    = "echo ${self.public_ip} > /home/nasg0725/Devops/Terraform/public_ip.txt"
  }

  root_block_device {
    volume_size           = var.os_disk_size
    volume_type           = var.os_disk_volume_type
    delete_on_termination = true
  }
  metadata_options {
    http_tokens                 = "required"   # IMDSv2 enforced
    http_put_response_hop_limit = 1           # Recommended default
    http_endpoint               = "enabled"   # Keep metadata accessible
  }

  tags = merge(local.common_tags, {
    Name = "${var.region}-${count.index}-nginx-vm"
  })
}

resource "aws_ebs_volume" "data-disks" {
  count = var.cnt
  availability_zone = var.availability_zones[var.region][count.index]
  size              = var.data-disks
  type = "gp3"
  encrypted = true
  tags = merge(local.common_tags, {
    Name = "ebs-data-disks-${count.index}"
  })
  depends_on = [
   aws_instance.my-instance
  ]
}

resource "aws_volume_attachment" "volume" {
  device_name = "/dev/sd${element(["f","g","h","i","j","k","l","m","n","o"], count.index)}"
  count = var.cnt
  volume_id   = aws_ebs_volume.data-disks[count.index].id
  instance_id = aws_instance.my-instance[count.index].id
  depends_on = [
    aws_ebs_volume.data-disks,
    aws_instance.my-instance
  ]
}


resource "aws_security_group" "common_access" {
  name        = "common-sg"
  description = "Allow 22, 80 access"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_ports
    iterator = port
    content {
     from_port   = port.value
     to_port     = port.value
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # "-1" allows all protocols
  }
  tags = merge(local.common_tags, {
    Name = "My Custom SG"
  })
}


output "aws_instance" {
  value = aws_instance.my-instance[0].id
}
output "aws_instance_public_ip" {
  value = aws_instance.my-instance[0].public_ip
}
