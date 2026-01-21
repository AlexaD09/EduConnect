output "environment" {
  value = var.environment
}

output "bastion_ip" {
  value = module.bastion.public_ip
}


output "bastion_eip" {
  value = aws_eip.bastion_eip.public_ip
}

