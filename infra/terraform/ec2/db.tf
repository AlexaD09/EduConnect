resource "aws_instance" "db" {
  ami           = "AMI_ID"
  instance_type = "t3.micro"
  subnet_id     = var.private_subnets[1]
  vpc_security_group_ids = [var.sg_db]

  user_data = file("${path.module}/userdata.sh")
}
