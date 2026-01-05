resource "aws_lb" "api_alb" {
  count              = var.account_type == "api-gateway" ? 1 : 0
  name               = "api-gateway-alb"
  load_balancer_type = "application"
  internal           = false

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  security_groups = [
    aws_security_group.alb_sg[0].id
  ]
}
