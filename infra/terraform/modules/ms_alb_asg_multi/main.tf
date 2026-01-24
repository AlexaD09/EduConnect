locals {
  is_prod = var.environment == "prod"
}

resource "aws_security_group" "alb_sg" {
  count  = local.is_prod ? 1 : 0
  name   = "${var.name}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from Bastion/API Gateway"
    from_port   = 80
    to_port     = 80
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

resource "aws_lb" "this" {
  count              = local.is_prod ? 1 : 0
  name               = var.name
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  security_groups    = [aws_security_group.alb_sg[0].id]
}

resource "aws_lb_listener" "http" {
  count             = local.is_prod ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}


resource "aws_security_group" "svc_sg" {
  for_each = local.is_prod ? var.services : {}

  name   = "${var.name}-${each.key}-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "App from ALB"
    from_port       = var.service_port
    to_port         = var.service_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg[0].id]
  }

  ingress {
    description = "SSH from Bastion"
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

data "aws_ami" "amazon_linux" {
  for_each   = local.is_prod ? var.services : {}
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_lb_target_group" "tg" {
  for_each = local.is_prod ? var.services : {}

  name     = "${substr(replace(var.name, "_", "-"), 0, 18)}-${substr(each.key,0,8)}"
  port     = var.service_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
  }
}

resource "aws_lb_listener_rule" "rule" {
  for_each = local.is_prod ? var.services : {}

  listener_arn = aws_lb_listener.http[0].arn
  priority     = 100 + index(keys(var.services), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }

  condition {
    path_pattern {
      values = ["${each.value}/*", each.value]
    }
  }
}

resource "aws_launch_template" "lt" {
  for_each = local.is_prod ? var.services : {}

  name_prefix   = "${var.name}-${each.key}-"
  image_id      = data.aws_ami.amazon_linux[each.key].id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.svc_sg[each.key].id]
  }

  
  user_data = base64encode("#!/bin/bash\necho 'svc up' > /tmp/svc.txt\n")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-${each.key}"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  for_each = local.is_prod ? var.services : {}

  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.lt[each.key].id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg[each.key].arn]
}
