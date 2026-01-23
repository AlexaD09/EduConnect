resource "aws_eip" "bastion" {
  domain = "vpc"

  tags = {
    Name        = "bastion-eip-${var.environment}"
    Environment = var.environment
  }
}
