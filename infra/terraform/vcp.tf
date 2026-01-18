# Una VPC por cuenta, dinámica por ambiente
resource "aws_vpc" "frontend" {
  provider   = aws.frontend
  cidr_block = var.vpc_cidr[var.env]
  tags = { Name = "${var.env}-frontend-vpc" }
}

resource "aws_vpc" "ms_a" {
  provider   = aws.ms_a
  cidr_block = var.vpc_cidr[var.env]
  tags = { Name = "${var.env}-ms-a-vpc" }
}

resource "aws_vpc" "ms_b" {
  provider   = aws.ms_b
  cidr_block = var.vpc_cidr[var.env]
  tags = { Name = "${var.env}-ms-b-vpc" }
}

resource "aws_vpc" "databases" {
  provider   = aws.databases
  cidr_block = var.vpc_cidr[var.env]
  tags = { Name = "${var.env}-databases-vpc" }
}

resource "aws_vpc" "bastion" {
  provider   = aws.bastion
  cidr_block = var.vpc_cidr[var.env]
  tags = { Name = "${var.env}-bastion-vpc" }
}