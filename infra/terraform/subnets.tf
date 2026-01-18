# Subnets Frontend
resource "aws_subnet" "frontend_public_a" {
  provider          = aws.frontend
  vpc_id            = var.env == "qa" ? aws_vpc.qa_frontend.id : aws_vpc.prod_frontend.id
  cidr_block        = var.env == "qa" ? "10.0.1.0/24" : "10.1.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "${var.env}-frontend-public-a" }
}

resource "aws_subnet" "frontend_public_b" {
  provider          = aws.frontend
  vpc_id            = var.env == "qa" ? aws_vpc.qa_frontend.id : aws_vpc.prod_frontend.id
  cidr_block        = var.env == "qa" ? "10.0.2.0/24" : "10.1.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "${var.env}-frontend-public-b" }
}

# Subnets Microservicios A
resource "aws_subnet" "ms_a_private_a" {
  provider          = aws.ms_a
  vpc_id            = var.env == "qa" ? aws_vpc.qa_ms_a.id : aws_vpc.prod_ms_a.id
  cidr_block        = var.env == "qa" ? "10.0.3.0/24" : "10.1.3.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "${var.env}-ms-a-private-a" }
}

resource "aws_subnet" "ms_a_private_b" {
  provider          = aws.ms_a
  vpc_id            = var.env == "qa" ? aws_vpc.qa_ms_a.id : aws_vpc.prod_ms_a.id
  cidr_block        = var.env == "qa" ? "10.0.4.0/24" : "10.1.4.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "${var.env}-ms-a-private-b" }
}

# Subnets Microservicios B
resource "aws_subnet" "ms_b_private_a" {
  provider          = aws.ms_b
  vpc_id            = var.env == "qa" ? aws_vpc.qa_ms_b.id : aws_vpc.prod_ms_b.id
  cidr_block        = var.env == "qa" ? "10.0.5.0/24" : "10.1.5.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "${var.env}-ms-b-private-a" }
}

resource "aws_subnet" "ms_b_private_b" {
  provider          = aws.ms_b
  vpc_id            = var.env == "qa" ? aws_vpc.qa_ms_b.id : aws_vpc.prod_ms_b.id
  cidr_block        = var.env == "qa" ? "10.0.6.0/24" : "10.1.6.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "${var.env}-ms-b-private-b" }
}

# Subnets Bases de datos
resource "aws_subnet" "databases_private_a" {
  provider          = aws.databases
  vpc_id            = var.env == "qa" ? aws_vpc.qa_databases.id : aws_vpc.prod_databases.id
  cidr_block        = var.env == "qa" ? "10.0.7.0/24" : "10.1.7.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "${var.env}-databases-private-a" }
}

resource "aws_subnet" "databases_private_b" {
  provider          = aws.databases
  vpc_id            = var.env == "qa" ? aws_vpc.qa_databases.id : aws_vpc.prod_databases.id
  cidr_block        = var.env == "qa" ? "10.0.8.0/24" : "10.1.8.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "${var.env}-databases-private-b" }
}

# Subnets Bastion
resource "aws_subnet" "bastion_public_a" {
  provider          = aws.bastion
  vpc_id            = var.env == "qa" ? aws_vpc.qa_bastion.id : aws_vpc.prod_bastion.id
  cidr_block        = var.env == "qa" ? "10.0.9.0/24" : "10.1.9.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "${var.env}-bastion-public-a" }
}

resource "aws_subnet" "bastion_public_b" {
  provider          = aws.bastion
  vpc_id            = var.env == "qa" ? aws_vpc.qa_bastion.id : aws_vpc.prod_bastion.id
  cidr_block        = var.env == "qa" ? "10.0.10.0/24" : "10.1.10.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "${var.env}-bastion-public-b" }
}