resource "aws_subnet" "qa_a" {
  provider = aws.frontend
  vpc_id   = aws_vpc.qa.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags = { Name = "${var.env}-qa-a" }
}

resource "aws_subnet" "qa_b" {
  provider = aws.frontend
  vpc_id   = aws_vpc.qa.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  tags = { Name = "${var.env}-qa-b" }
}

resource "aws_subnet" "prod_a" {
  provider = aws.frontend
  vpc_id   = aws_vpc.prod.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "${var.region}a"
  tags = { Name = "${var.env}-prod-a" }
}

resource "aws_subnet" "prod_b" {
  provider = aws.frontend
  vpc_id   = aws_vpc.prod.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "${var.region}b"
  tags = { Name = "${var.env}-prod-b" }
}
