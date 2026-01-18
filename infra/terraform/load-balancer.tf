# Load Balancers solo para PROD
resource "aws_lb" "frontend" {
  count               = var.env == "prod" ? 1 : 0
  provider            = aws.frontend
  name                = "${var.env}-frontend-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.frontend[0].id]
  subnets             = var.env == "prod" ? [
    # En PROD usas subnets específicas
    "subnet-12345",  # Reemplaza con IDs reales de PROD
    "subnet-67890"
  ] : []
}

resource "aws_lb_target_group" "frontend" {
  count           = var.env == "prod" ? 1 : 0
  provider        = aws.frontend
  name            = "${var.env}-frontend-tg"
  port            = 80
  protocol        = "HTTP"
  vpc_id          = var.env == "prod" ? "vpc-12345" : ""  # Reemplaza con VPC ID real de PROD
  target_type     = "instance"
}