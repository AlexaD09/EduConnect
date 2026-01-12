provider "aws" {
  region = "us-east-1"
}

####################
# VPC
####################
resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "prod-rt"
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
  tags = {
    Name = "prod-subnet-a"
  }
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "prod-subnet-b"
  }
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
  name   = "prod-sg"

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

  tags = {
    Name = "prod-security-group"
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
  tags = {
    Name = "prod-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "prod-tg-final"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.prod.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "prod-target-group"
  }
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
  image_id      = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  instance_type = "t3.micro"

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Pull y ejecuta SOLO el API Gateway en puerto 80
docker run -d \
  --name api-gateway \
  --restart unless-stopped \
  -p 80:80 \
  alexa1209/api-gateway:latest
EOF
  )

  network_interfaces {
    security_groups = [aws_security_group.sg.id]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "prod-instance"
    }
  }
}

####################
# ASG
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

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "prod-asg"
    propagate_at_launch = true
  }
}

####################
# OUTPUT
####################
output "alb_dns" {
  value = aws_lb.alb.dns_name
  description = "DNS name of the Application Load Balancer"
}