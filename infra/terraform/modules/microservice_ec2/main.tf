terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_security_group" "microservice_sg" {
  vpc_id = var.vpc_id

  ingress {
    description = "SSH from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_cidr]
  }

  ingress {
    description = "App port (only from allowed CIDRs)"
    from_port   = var.allowed_app_port
    to_port     = var.allowed_app_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_app_cidrs
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "microservice" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids      = [aws_security_group.microservice_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"

  user_data = var.user_data

  tags = {
    Name = "${var.name}-${count.index + 1}"
  }
}
