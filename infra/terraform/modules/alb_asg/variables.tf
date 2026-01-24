variable "name" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "allowed_http_cidr" { type = string }

variable "internal" {
  description = "If true, the ALB is internal (recommended for private microservices)"
  type        = bool
  default     = true
}

variable "bastion_cidr" {
  description = "CIDR allowed for SSH (VPC/Bastion Subnet)"
  type        = string
}
