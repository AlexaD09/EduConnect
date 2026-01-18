# VPC QA
resource "aws_vpc" "qa_frontend" {
  provider   = aws.frontend
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.env}-frontend-vpc" }
}

resource "aws_vpc" "qa_ms_a" {
  provider   = aws.ms_a
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.env}-ms-a-vpc" }
}

resource "aws_vpc" "qa_ms_b" {
  provider   = aws.ms_b
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.env}-ms-b-vpc" }
}

resource "aws_vpc" "qa_databases" {
  provider   = aws.databases
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.env}-databases-vpc" }
}

resource "aws_vpc" "qa_bastion" {
  provider   = aws.bastion
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.env}-bastion-vpc" }
}

# VPC PROD
resource "aws_vpc" "prod_frontend" {
  provider   = aws.frontend
  cidr_block = "10.1.0.0/16"
  tags = { Name = "${var.env}-frontend-vpc" }
}

resource "aws_vpc" "prod_ms_a" {
  provider   = aws.ms_a
  cidr_block = "10.1.0.0/16"
  tags = { Name = "${var.env}-ms-a-vpc" }
}

resource "aws_vpc" "prod_ms_b" {
  provider   = aws.ms_b
  cidr_block = "10.1.0.0/16"
  tags = { Name = "${var.env}-ms-b-vpc" }
}

resource "aws_vpc" "prod_databases" {
  provider   = aws.databases
  cidr_block = "10.1.0.0/16"
  tags = { Name = "${var.env}-databases-vpc" }
}

resource "aws_vpc" "prod_bastion" {
  provider   = aws.bastion
  cidr_block = "10.1.0.0/16"
  tags = { Name = "${var.env}-bastion-vpc" }
}