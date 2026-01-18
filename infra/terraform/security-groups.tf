# Security Group Bastion QA
resource "aws_security_group" "qa_bastion" {
  provider = aws.bastion
  vpc_id   = aws_vpc.qa_bastion.id
  name     = "qa-bastion-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]  # Solo tu IP
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group Frontend QA
resource "aws_security_group" "qa_frontend" {
  provider = aws.frontend
  vpc_id   = aws_vpc.qa_frontend.id
  name     = "qa-frontend-sg"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Tráfico público
  }
  
  # Solo el Bastion puede acceder vía SSH
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.qa_bastion.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group Internal QA (Microservicios y DB)
resource "aws_security_group" "qa_internal" {
  provider = aws.ms_a  # Se replica en ms_b y databases
  vpc_id   = aws_vpc.qa_ms_a.id
  name     = "qa-internal-sg"
  
  # Solo el Bastion puede acceder vía SSH
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.qa_bastion.id]
  }
  
  # Comunicación interna entre servicios
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Solo tráfico QA
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}