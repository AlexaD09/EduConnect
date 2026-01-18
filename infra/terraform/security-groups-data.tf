data "aws_security_group" "frontend" {
  provider = aws.frontend
  name     = "${var.env}-frontend-sg"
}

data "aws_security_group" "internal_ms_a" {
  provider = aws.ms_a
  name     = "${var.env}-ms-a-internal-sg"
}

data "aws_security_group" "internal_ms_b" {
  provider = aws.ms_b
  name     = "${var.env}-ms-b-internal-sg"
}

data "aws_security_group" "internal_databases" {
  provider = aws.databases
  name     = "${var.env}-databases-internal-sg"
}

data "aws_security_group" "bastion" {
  provider = aws.bastion
  name     = "${var.env}-bastion-sg"
}
