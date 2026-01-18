# Bastion Host
resource "aws_instance" "bastion" {
  count    = 1
  provider = aws.bastion
  ami      = var.ami_id
  instance_type = "t3.micro"
  tags = { Name = "qa-bastion" }
}

# API Gateway Frontend
resource "aws_instance" "api_gateway_frontend" {
  count    = 1
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8000:80 nginx
EOF
  )
  tags = { Name = "qa-api-gateway-frontend" }
}

# User Service (ejemplo)
resource "aws_instance" "user_service" {
  count    = 1
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8001:8000 alexa1209/user-service:latest
EOF
  )
  tags = { Name = "qa-user-service" }
}

# PostgreSQL (ejemplo)
resource "aws_instance" "postgres" {
  count    = 1
  provider = aws.databases
  ami      = var.ami_id
  instance_type = var.instance_type
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:15
EOF
  )
  tags = { Name = "qa-postgres" }
}