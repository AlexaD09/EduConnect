resource "aws_instance" "nginx" {
  ami                    = "AMI_ID"
  instance_type           = "t3.micro"
  subnet_id               = var.public_subnets[0]
  vpc_security_group_ids  = [var.sg_nginx]
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata.sh")
}
