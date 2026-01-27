
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "shared" {
  key_name   = "prueba-${var.environment}-v2"
  public_key = tls_private_key.ssh.public_key_openssh
}


