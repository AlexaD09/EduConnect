resource "aws_lb_listener" "http" {
  count             = var.account_type == "api-gateway" ? 1 : 0
  load_balancer_arn = aws_lb.api_alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "API Gateway OK - Infra Ready"
      status_code  = "200"
    }
  }
}
