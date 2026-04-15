resource "aws_instance" "my-server" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = var.server_name
  tags = {
    Name = each.value
  }
}

output "import_sg" {
  value = data.aws_security_groups.import
}

import {
  to = aws_security_group.my-default-sg
  id = data.aws_security_groups.import.ids[0]
}
