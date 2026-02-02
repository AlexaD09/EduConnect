variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "key_name" { type = string }

variable "bastion_cidr" {
  description = "CIDR allowed for SSH (VPC/Bastion Subnet)"
  type        = string
}

variable "allowed_app_port" { type = number }

variable "instance_count" {
  description = "Number of instances (microservices) to create"
  type        = number
}


variable "associate_public_ip" {
  description = "If true, the instance will have a public IP (only for api-gateway)"
  type        = bool
  default     = false
}

variable "allowed_app_cidrs" {
  description = "CIDRs allowed for the app port"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data for bootstrap (optional)"
  type        = string
  default     = null
}


