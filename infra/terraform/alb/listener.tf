resource "aws_lb_target_group" "app" {
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }#no
}
