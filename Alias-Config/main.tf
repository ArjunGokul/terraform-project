resource "aws_security_group" "dev" {
  name     = "dev-sg"
  provider = aws.mumbai
}

resource "aws_security_group" "prod" {
  name     = "prod-sg"
  provider = aws.usa
}
