# Security Group Frontend
resource "aws_security_group" "frontend" {
  provider = aws.frontend
  vpc_id   = aws_vpc.frontend.id
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
  vpc_id   = aws_vpc.bastion.id
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
  vpc_id   = aws_vpc.ms_a.id
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
    cidr_blocks = [var.vpc_cidr[var.env]]
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
  vpc_id   = aws_vpc.ms_b.id
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
    cidr_blocks = [var.vpc_cidr[var.env]]
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
  vpc_id   = aws_vpc.databases.id
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
    cidr_blocks = [var.vpc_cidr[var.env]]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}