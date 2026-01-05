resource "aws_lb_target_group" "service_tg" {
  count    = var.account_type == "qa-service" || var.account_type == "prod-service" ? 1 : 0
  name     = "${var.account_type}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Env = var.env
  }
}
