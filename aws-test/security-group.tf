resource "aws_security_group" "security-group" {
  name        = "ingress-traffic"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.vpc.id
  tags = merge(local.common_tags, {
    Name = "My Ingress Security group"
  })
}

resource "aws_vpc_security_group_ingress_rule" "security_ingress" {
  for_each = toset([for p in var.ingress_ports : tostring(p)])

  security_group_id = aws_security_group.security-group.id
  cidr_ipv4         = "14.194.163.180/32"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  ip_protocol       = "tcp"
  depends_on = [
    aws_instance.example
  ]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  depends_on = [
    aws_instance.example
  ]
}