# Load Balancers solo para PROD
resource "aws_lb" "frontend" {
  count               = var.env == "prod" ? 1 : 0
  provider            = aws.frontend
  name                = "${var.env}-frontend-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.frontend.id]
  subnets             = [
    aws_subnet.qa_frontend_public_a.id,
    aws_subnet.qa_frontend_public_b.id
  ]
}

resource "aws_lb_target_group" "frontend" {
  count           = var.env == "prod" ? 1 : 0
  provider        = aws.frontend
  name            = "${var.env}-frontend-tg"
  port            = 80
  protocol        = "HTTP"
  vpc_id          = var.env == "qa" ? aws_vpc.qa_frontend.id : aws_vpc.prod_frontend.id
  target_type     = "instance"
}