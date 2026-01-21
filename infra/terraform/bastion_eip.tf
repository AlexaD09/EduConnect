resource "aws_eip" "bastion_eip" {
  provider = aws.bastion
  domain   = "vpc"

  tags = {
    Name = "bastion-eip-${var.environment}"
  }
}

resource "aws_eip_association" "bastion_eip_assoc" {
  provider      = aws.bastion
  instance_id   = module.bastion.instance_id
  allocation_id = aws_eip.bastion_eip.id
}
