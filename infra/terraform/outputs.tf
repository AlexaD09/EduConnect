output "environment" {
  value = var.env
}

output "instance_count" {
  value = var.env == "qa" ? 1 : 0
}