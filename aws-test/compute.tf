resource "aws_instance" "example" {
  for_each = local.instance_map

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.my_key.key_name
  user_data     = file("./install-nginx.sh")

  availability_zone = data.aws_availability_zones.available.names[
    each.value % length(data.aws_availability_zones.available.names)
  ]

  vpc_security_group_ids = [
    aws_security_group.security-group.id
  ]

  root_block_device {
    volume_size = var.volume_size
  }

  tags = merge(local.common_tags, {
    Name = each.key
  })
}