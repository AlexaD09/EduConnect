resource "aws_eip" "bastion_eip" {
  provider = aws.bastion
  domain   = "vpc"
}

resource "aws_eip_association" "bastion_eip_assoc" {
  provider      = aws.bastion
  instance_id   = module.bastion.instance_id
  allocation_id = var.bastion_eip_allocation_id
  
}
