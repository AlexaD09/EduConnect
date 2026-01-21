output "instance_ids" {
  description = "EC2 instance IDs of the microservice"
  value       = aws_instance.microservice[*].id
}

output "security_group_id" {
  description = "Microservice Security Group"
  value       = aws_security_group.microservice_sg.id
}

output "private_ips" {
  description = "Private IPs of the instances (for NGINX reverse proxy)"
  value       = aws_instance.microservice[*].private_ip
}
