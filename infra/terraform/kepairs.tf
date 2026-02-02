
resource "aws_key_pair" "bastion" {
  provider   = aws.bastion
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key

  tags = {
    Name        = var.ssh_key_name
    Environment = var.environment
  }
}

resource "aws_key_pair" "frontend" {
  provider   = aws.frontend
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key

  tags = {
    Name        = var.ssh_key_name
    Environment = var.environment
  }
}

resource "aws_key_pair" "microservices_a" {
  provider   = aws.microservices_a
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key

  tags = {
    Name        = var.ssh_key_name
    Environment = var.environment
  }
}

resource "aws_key_pair" "microservices_b" {
  provider   = aws.microservices_b
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key

  tags = {
    Name        = var.ssh_key_name
    Environment = var.environment
  }
}

resource "aws_key_pair" "data" {
  provider   = aws.data
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key

  tags = {
    Name        = var.ssh_key_name
    Environment = var.environment
  }
}
