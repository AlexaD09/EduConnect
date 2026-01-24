variable "environment" {
  description = "qa o prod"
  type        = string
  validation {
    condition     = contains(["qa", "prod"], var.environment)
    error_message = "environment must be qa or prod"
  }
}

variable "region" { type = string }

variable "bastion_access_key" { type = string }
variable "bastion_secret_key" { type = string }
variable "bastion_session_token" { type = string }
