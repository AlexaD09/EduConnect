# Security Group para ALB (API Gateway)
resource "aws_security_group" "alb_sg" {
  count  = var.account_type == "api-gateway" ? 1 : 0
  name   = "alb-sg"
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

# Security Group para microservicios QA / PROD
resource "aws_security_group" "service_sg" {
  count  = var.account_type == "qa-service" || var.account_type == "prod-service" ? 1 : 0
  name   = "service-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
