# Security Group Frontend
resource "aws_security_group" "frontend" {
  provider = aws.frontend
  vpc_id   = var.env == "qa" ? aws_vpc.qa_frontend.id : aws_vpc.prod_frontend.id
  name     = "${var.env}-frontend-sg"
  
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
  name     = "${var.env}-bastion-sg"
  
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

# Security Group Internal MS-A
resource "aws_security_group" "internal_ms_a" {
  provider = aws.ms_a
  vpc_id   = var.env == "qa" ? aws_vpc.qa_ms_a.id : aws_vpc.prod_ms_a.id
  name     = "${var.env}-ms-a-internal-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
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

# Security Group Internal MS-B
resource "aws_security_group" "internal_ms_b" {
  provider = aws.ms_b
  vpc_id   = var.env == "qa" ? aws_vpc.qa_ms_b.id : aws_vpc.prod_ms_b.id
  name     = "${var.env}-ms-b-internal-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
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

# Security Group Internal Databases
resource "aws_security_group" "internal_databases" {
  provider = aws.databases
  vpc_id   = var.env == "qa" ? aws_vpc.qa_databases.id : aws_vpc.prod_databases.id
  name     = "${var.env}-databases-internal-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
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