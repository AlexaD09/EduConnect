resource "aws_instance" "qa" {
  ami           = "AMI_ID"
  instance_type = "t3.micro"
  subnet_id     = var.private_subnets[0]
  vpc_security_group_ids = [var.sg_app]

  user_data = file("${path.module}/userdata.sh")
}
