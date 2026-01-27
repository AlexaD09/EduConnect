
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "aws_key_pair" "shared" {
  key_name   = "prueba-${var.environment}"
  public_key = file(var.public_key_path)
}
