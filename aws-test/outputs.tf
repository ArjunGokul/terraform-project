output "instance_id" {
  value = { for k, v in aws_instance.example : k => v.id }
}

output "instance_public_ip" {
  value = { for k, v in aws_instance.example : k => v.public_ip }
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example : s.cidr_block]
}

output "key_pair" {
  value = data.aws_key_pair.my_key
  #sensitive   = true
}
