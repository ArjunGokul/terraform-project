locals {
  common_tags = {
   Project = "Terraform"
   Owner   = "Arjun"
  }
}

/*resource "aws_iam_user" "create-users" {
  for_each = toset(var.create_users)
  name = each.value
  tags = merge(local.common_tags,{
   Name = "Creating IAM Users"
  })
}*/

data "aws_iam_users" "get" {
  #depends_on = [ aws_iam_user.create-users ]
}

data "aws_iam_policy" "example" {
   for_each = toset(var.IAMPolicy)
   name = each.value
   #depends_on = [ aws_iam_user.create-users ]
}
resource "aws_iam_policy_attachment" "attach" {
  for_each = data.aws_iam_policy.example
  policy_arn = each.value.arn
  name = "attach-policy-${each.key}"
  users = data.aws_iam_users.get.names
}
