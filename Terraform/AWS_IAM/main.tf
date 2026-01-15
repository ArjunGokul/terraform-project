resource "aws_iam_user" "Gokul" {
  name = "Gokul"
  tags = {
    Project     = "POC"
    Name        = "IAM User"
    Description = "IAM User Created"
  }
}

resource "aws_iam_policy" "iam_policy" {
  policy = file("./admin-policy.json")
  tags = {
    Project     = "POC"
    Description = "Attaching Admin Policy for User : ${aws_iam_user.Gokul.name}"
  }
}

resource "aws_iam_user_policy_attachment" "iam_attach_policy" {
  user       = aws_iam_user.Gokul.name
  policy_arn = aws_iam_policy.iam_policy.arn
  depends_on = [
    aws_iam_user.Gokul,
    aws_iam_policy.iam_policy
  ]
}
