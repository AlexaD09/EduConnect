resource "aws_instance" "bastion" {
  ami           = "AMI_ID"
  instance_type = "t3.micro"
  subnet_id     = var.public_subnets[0]
  vpc_security_group_ids = [var.sg_bastion]
}
