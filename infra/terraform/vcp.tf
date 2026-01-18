resource "aws_vpc" "qa" {
  provider   = aws.frontend
  cidr_block = var.vpc_cidr_qa
  tags = { Name = "${var.env}-qa-vpc" }
}

resource "aws_vpc" "prod" {
  provider   = aws.frontend
  cidr_block = var.vpc_cidr_prod
  tags = { Name = "${var.env}-prod-vpc" }
}
