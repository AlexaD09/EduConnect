
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "aws_key_pair" "frontend" {
  provider   = aws.frontend
  key_name   = "${var.key_name}-${var.environment}"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_key_pair" "microservices_a" {
  provider   = aws.microservices_a
  key_name   = "${var.key_name}-${var.environment}"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_key_pair" "microservices_b" {
  provider   = aws.microservices_b
  key_name   = "${var.key_name}-${var.environment}"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_key_pair" "data" {
  provider   = aws.data
  key_name   = "${var.key_name}-${var.environment}"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_key_pair" "bastion" {
  provider   = aws.bastion
  key_name   = "${var.key_name}-${var.environment}"
  public_key = tls_private_key.ssh.public_key_openssh
}
