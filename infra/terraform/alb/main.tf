resource "aws_lb" "this" {
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [var.alb_sg]
}

resource "aws_lb_target_group" "app" {
  port     = 80
  protocol = "HTTP"
  vpc_id  = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
