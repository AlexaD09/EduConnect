

locals {
  is_prod = var.environment == "prod"
}




resource "aws_security_group" "alb_sg" {
  count       = local.is_prod ? 1 : 0
  name        = "${var.name}-alb-sg"
  description = "SG para ALB (solo PROD)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb-sg"
  }
}




resource "aws_lb" "this" {
  count              = local.is_prod ? 1 : 0
  name               = var.name
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  internal           = var.internal
  security_groups    = [aws_security_group.alb_sg[0].id]

  tags = {
    Environment = var.environment
  }
}




resource "aws_lb_target_group" "this" {
  count    = local.is_prod ? 1 : 0
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id  = var.vpc_id

  health_check {
    path = "/"
  }
}




resource "aws_lb_listener" "this" {
  count             = local.is_prod ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}



resource "aws_security_group" "ec2_sg" {
  count  = local.is_prod ? 1 : 0
  name   = "${var.name}-ec2-sg"
  vpc_id = var.vpc_id

  # Tráfico solo desde ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg[0].id]
  }

  # SSH solo desde Bastion (por CIDR, no SG cross-account)
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.bastion_cidr]
}


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_launch_template" "this" {
  count         = local.is_prod ? 1 : 0
  name_prefix   = var.name
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg[0].id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.name
    }
  }
}




resource "aws_autoscaling_group" "this" {
  count               = local.is_prod ? 1 : 0
  desired_capacity    = 2
  min_size            = 1
  max_size            = 4
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.this[0].id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.this[0].arn]

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}
