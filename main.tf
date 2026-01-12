resource "aws_instance" "nginx-server" {
  instance_type = var.instance_type
  ami = var.ami
  tags = {
   Name = "nginx-server-01"
  }
}
