output "alb_dns_name" {
  description = "ALB DNS (PROD only)"
  value       = local.is_prod ? aws_lb.this[0].dns_name : null
}
