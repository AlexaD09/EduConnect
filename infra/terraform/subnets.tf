# Subnets QA Frontend
resource "aws_subnet" "qa_frontend_public_a" {
  provider          = aws.frontend
  vpc_id            = aws_vpc.qa_frontend.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "qa-frontend-public-a" }
}

resource "aws_subnet" "qa_frontend_public_b" {
  provider          = aws.frontend
  vpc_id            = aws_vpc.qa_frontend.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "qa-frontend-public-b" }
}

# Subnets QA Microservicios A
resource "aws_subnet" "qa_ms_a_private_a" {
  provider          = aws.ms_a
  vpc_id            = aws_vpc.qa_ms_a.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "qa-ms-a-private-a" }
}

resource "aws_subnet" "qa_ms_a_private_b" {
  provider          = aws.ms_a
  vpc_id            = aws_vpc.qa_ms_a.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "qa-ms-a-private-b" }
}

# ... (continuar con todas las subnets QA)

# Subnets Bastion QA
resource "aws_subnet" "qa_bastion_public_a" {
  provider          = aws.bastion
  vpc_id            = aws_vpc.qa_bastion.id
  cidr_block        = "10.0.9.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "qa-bastion-public-a" }
}

resource "aws_subnet" "qa_bastion_public_b" {
  provider          = aws.bastion
  vpc_id            = aws_vpc.qa_bastion.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "qa-bastion-public-b" }
}