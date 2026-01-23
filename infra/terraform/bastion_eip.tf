# infra/terraform/bastion_eip.tf

variable "bastion_eip_allocation_id" {
  description = "Allocation ID del EIP creado por el stack infra/terraform-eip"
  type        = string
}

resource "aws_eip_association" "bastion_eip_assoc" {
  provider      = aws.bastion
  instance_id   = module.bastion.instance_id
  allocation_id = var.bastion_eip_allocation_id
}
