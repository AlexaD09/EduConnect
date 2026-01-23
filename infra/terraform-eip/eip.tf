resource "aws_eip" "bastion" {
  domain = "vpc"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "bastion-eip-${var.environment}"
  }
}
