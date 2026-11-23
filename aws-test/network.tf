# resource "aws_network_interface" "attach-network-interface" {
#   for_each = local.instance_map

#   subnet_id = aws_instance.example[each.key].subnet_id

#   security_groups = [
#     aws_security_group.security-group.id
#   ]

#   tags = merge(local.common_tags, {
#     Name = "${each.key}-eni"
#   })
# }

# resource "aws_network_interface_attachment" "attachment" {
#   for_each = local.instance_map

#   instance_id          = aws_instance.example[each.key].id
#   network_interface_id = aws_network_interface.attach-network-interface[each.key].id
#   device_index         = 1
# }