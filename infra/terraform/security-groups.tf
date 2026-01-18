# Security Group Frontend (API Gateway)
resource "aws_security_group" "frontend" {
  provider = aws.frontend
  vpc_id   = var.env == "qa" ? aws_vpc.qa_frontend.id : aws_vpc.prod_frontend.id
  
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

# Security Group Bastion
resource "aws_security_group" "bastion" {
  provider = aws.bastion
  vpc_id   = var.env == "qa" ? aws_vpc.qa_bastion.id : aws_vpc.prod_bastion.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group Internal (microservicios y DB)
resource "aws_security_group" "internal" {
  provider = aws.ms_a
  vpc_id   = var.env == "qa" ? aws_vpc.qa_ms_a.id : aws_vpc.prod_ms_a.id
  
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.env == "qa" ? ["10.0.0.0/16"] : ["10.1.0.0/16"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}