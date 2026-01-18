# Security Group Bastion - solo permite tu IP
resource "aws_security_group" "bastion" {
  count    = 1
  provider = aws.bastion
  name     = "${var.env}-bastion-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]  # Solo tu IP puede acceder
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group Frontend - aislado por ambiente
resource "aws_security_group" "frontend" {
  count    = 1
  provider = aws.frontend
  name     = "${var.env}-frontend-sg"
  
  # SSH solo desde Bastion del mismo ambiente
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = [var.admin_cidr]  # Solo tu IP
  }
  
  # HTTP público
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

# Security Group Internal - aislado por ambiente
resource "aws_security_group" "internal" {
  count    = 1
  provider = aws.ms_a  # Se replica en otras cuentas
  name     = "${var.env}-internal-sg"
  
  # SSH solo desde tu IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }
  
  # Comunication  interna
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]  #default vcp
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}