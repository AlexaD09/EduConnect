########################################
# TERRAFORM & PROVIDER
########################################
terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

########################################
# VPC (Simulates one AWS Account)
########################################
# This VPC represents ONE isolated AWS account
# (QA or PROD). Multi-account is simulated by
# having separate VPCs / states.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

########################################
# SUBNETS
########################################
# Public subnet → Internet / API Gateway
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Private subnet → ALB + Microservices
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
}

########################################
# ROUTE TABLES
########################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

########################################
# SECURITY GROUPS
########################################

# Internet → NGINX (API Gateway)
resource "aws_security_group" "nginx_sg" {
  vpc_id = aws_vpc.main.id

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

# NGINX → ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB → Microservices
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# API GATEWAY (NGINX EC2)
########################################
# This EC2 acts as a Docker-based API Gateway
resource "aws_instance" "nginx" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
EOF
}

# Static IP → Required for API Gateway
resource "aws_eip" "api_gateway_ip" {
  instance = aws_instance.nginx.id
}

########################################
# APPLICATION LOAD BALANCER (PRIVATE)
########################################
resource "aws_lb" "alb" {
  internal           = true
  load_balancer_type = "application"
  subnets            = [aws_subnet.private.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "app_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

########################################
# AUTO SCALING GROUP (PROD ONLY)
########################################
# PROD environment with CI/CD via Instance Refresh
resource "aws_launch_template" "prod" {
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir -p /opt/app
cd /opt/app

cat <<EOT > docker-compose.yml
version: "3.9"
services:
  api-gateway:
    image: alexa1209/api-gateway:latest
    ports:
      - "80:80"

  user-service:
    image: alexa1209/user-service:latest

  activity-service:
    image: alexa1209/activity-service:latest

  approval-service:
    image: alexa1209/approval-service:latest
EOT

docker pull alexa1209/api-gateway:latest
docker pull alexa1209/user-service:latest
docker pull alexa1209/activity-service:latest
docker pull alexa1209/approval-service:latest

docker-compose up -d
EOF
)
}

resource "aws_autoscaling_group" "prod" {
  name             = "prod-asg"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  # Private subnet where EC2s will live
  vpc_zone_identifier = [aws_subnet.private.id]

  # ALB Target Group where instances register
  target_group_arns = [
    aws_lb_target_group.app_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.prod.id
    version = "$Latest"
  }
}

