resource "aws_lb" "frontend" {
  count               = var.env == "prod" ? 1 : 0
  provider            = aws.frontend
  name                = "${var.env}-frontend-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = var.env == "prod" ? [aws_security_group.frontend[0].id] : null
  subnets             = var.env == "prod" ? ["subnet-12345", "subnet-67890"] : null
}

resource "aws_lb_target_group" "frontend" {
  count           = var.env == "prod" ? 1 : 0
  provider        = aws.frontend
  name            = "${var.env}-frontend-tg"
  port            = 80
  protocol        = "HTTP"
  vpc_id          = var.env == "prod" ? "vpc-12345" : null
  target_type     = "instance"
}