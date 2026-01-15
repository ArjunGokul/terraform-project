resource "aws_instance" "my-server" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = var.server_name
  tags = {
    Name = each.value
  }
}
