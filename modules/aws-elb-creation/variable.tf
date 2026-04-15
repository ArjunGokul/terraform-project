variable "region" {
  type = string
}

variable "aws_instances" {
  type = list(string)
}

variable "aws_security_group_id" {
  type = string
}
