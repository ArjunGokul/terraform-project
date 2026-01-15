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
data "aws_vpc" "default-vpc" {
  id = "vpc-0ce30347b3cd6bab8"
}

resource "aws_vpc" "default-vpc" {

}

resource "aws_instance" "my-instance" {
  instance_type = var.instance_type
  ami           = var.ami
  count         = var.cnt
  key_name      = aws_key_pair.my-keypair.key_name
  user_data     = file("install-nginx.sh")
  provisioner "remote-exec" {
    inline = ["sudo apt-get update -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/nasg0725/Devops/Terraform/myprivate.key")
  }
  vpc_security_group_ids = [aws_security_group.common_access.id]
  depends_on = [
    tls_private_key.my_key
  ]
  provisioner "local-exec" {
   command = "echo ${aws_instance.my-instance[count.index].public_ip} > /arjun/ip.txt"
  }

}


resource "aws_security_group" "common_access" {
  name        = "common-sg"
  description = "Allow HTTP access"
  vpc_id      = data.aws_vpc.default-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # "-1" allows all protocols
  }
}


output "aws_instance" {
  value = aws_instance.my-instance[0].id
}
output "aws_instance_public_ip" {
  value = aws_instance.my-instance[0].public_ip
}
