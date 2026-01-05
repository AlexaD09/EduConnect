variable "account_type" {
  description = "Tipo de cuenta: api-gateway | qa-service | prod-service | data | bastion"
  type        = string
}

variable "env" {
  description = "Entorno: qa | prod"
  type        = string
}
