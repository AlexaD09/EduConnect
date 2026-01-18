# VPCs QA
resource "aws_vpc" "qa_frontend" {
  provider   = aws.frontend
  cidr_block = "10.0.0.0/16"
  tags = { Name = "qa-frontend-vpc" }
}

resource "aws_vpc" "qa_ms_a" {
  provider   = aws.ms_a
  cidr_block = "10.0.0.0/16"
  tags = { Name = "qa-ms-a-vpc" }
}

resource "aws_vpc" "qa_ms_b" {
  provider   = aws.ms_b
  cidr_block = "10.0.0.0/16"
  tags = { Name = "qa-ms-b-vpc" }
}

resource "aws_vpc" "qa_databases" {
  provider   = aws.databases
  cidr_block = "10.0.0.0/16"
  tags = { Name = "qa-databases-vpc" }
}

resource "aws_vpc" "qa_bastion" {
  provider   = aws.bastion
  cidr_block = "10.0.0.0/16"
  tags = { Name = "qa-bastion-vpc" }
}

# VPCs PROD
resource "aws_vpc" "prod_frontend" {
  provider   = aws.frontend
  cidr_block = "10.1.0.0/16"
  tags = { Name = "prod-frontend-vpc" }
}

resource "aws_vpc" "prod_ms_a" {
  provider   = aws.ms_a
  cidr_block = "10.1.0.0/16"
  tags = { Name = "prod-ms-a-vpc" }
}

resource "aws_vpc" "prod_ms_b" {
  provider   = aws.ms_b
  cidr_block = "10.1.0.0/16"
  tags = { Name = "prod-ms-b-vpc" }
}

resource "aws_vpc" "prod_databases" {
  provider   = aws.databases
  cidr_block = "10.1.0.0/16"
  tags = { Name = "prod-databases-vpc" }
}

resource "aws_vpc" "prod_bastion" {
  provider   = aws.bastion
  cidr_block = "10.1.0.0/16"
  tags = { Name = "prod-bastion-vpc" }
}