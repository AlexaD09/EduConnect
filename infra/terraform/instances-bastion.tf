resource "aws_instance" "bastion" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.bastion
  ami      = var.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.bastion[count.index].id]
  tags = { Name = "${var.env}-bastion" }
}