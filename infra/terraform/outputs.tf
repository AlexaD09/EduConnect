output "api_subnet_id" {
  description = "Subnet donde vive el API Gateway"
  value       = aws_subnet.api.id
}

output "frontend_instance_ids" {
  description = "Instancias frontend (web, mobile, desktop)"
  value       = aws_instance.frontend[*].id
}

output "security_groups" {
  description = "Security Groups principales"
  value = {
    api_gateway = aws_security_group.api.id
    internal    = aws_security_group.internal.id
    bastion     = aws_security_group.bastion.id
  }
}
