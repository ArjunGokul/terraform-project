resource "aws_ebs_volume" "root" {
  for_each = local.instance_map

  availability_zone = aws_instance.example[each.key].availability_zone
  size              = var.volume_size

  tags = merge(local.common_tags, {
    Name = "${each.key}-volume"
  })
}

resource "aws_volume_attachment" "attachment" {
  for_each = local.instance_map

  device_name = local.device_names[each.value]

  volume_id   = aws_ebs_volume.root[each.key].id
  instance_id = aws_instance.example[each.key].id
}