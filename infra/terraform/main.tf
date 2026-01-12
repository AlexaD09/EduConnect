provider "aws" {
  region = "us-east-1"
}

####################
# VPC
####################
resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

####################
# SUBNETS (2 AZ OBLIGATORIO PARA ALB)
####################
resource "aws_subnet" "a" {
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.rt.id
}

####################
# SECURITY GROUP
####################
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.prod.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

####################
# ALB
####################
resource "aws_lb" "alb" {
  name               = "prod-alb-final"
  load_balancer_type = "application"
  subnets            = [aws_subnet.a.id, aws_subnet.b.id]
  security_groups    = [aws_security_group.sg.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "prod-tg-final"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.prod.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

####################
# LAUNCH TEMPLATE
####################
resource "aws_launch_template" "lt" {
  name_prefix   = "prod-lt-"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install docker -y
service docker start
docker run -d -p 80:8000 your_dockerhub_user/tu_imagen:latest
EOF
  )

  network_interfaces {
    security_groups = [aws_security_group.sg.id]
  }
}

####################
# ASG (NOMBRE NUEVO → NO ERROR)
####################
resource "aws_autoscaling_group" "asg" {
  name = "prod-asg-final"

  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  vpc_zone_identifier = [
    aws_subnet.a.id,
    aws_subnet.b.id
  ]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
}

####################
# OUTPUT
####################
output "alb_dns" {
  value = aws_lb.alb.dns_name
}
