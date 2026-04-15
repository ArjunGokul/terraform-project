data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_elb" "my-alb" {
  name = "my-alb"
  availability_zones = data.aws_availability_zones.available.names[*]
  instances = var.aws_instance[*]
  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

resource "aws_lb" "demo-alb" {
  name               = "demo-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

output "availability_zones" {
  value = data.aws_availability_zones.available
}
