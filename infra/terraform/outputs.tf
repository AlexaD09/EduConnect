output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns" {
  value       = var.account_type == "api-gateway" ? aws_lb.api_alb[0].dns_name : null
  description = "DNS del Application Load Balancer"
}

output "target_group_arn" {
  value = (
    var.account_type == "qa-service" || var.account_type == "prod-service"
  ) ? aws_lb_target_group.service_tg[0].arn : null
}

output "environment" {
  value = var.env
}

output "account_type" {
  value = var.account_type
}
