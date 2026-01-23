
variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["qa", "prod"], var.environment)
    error_message = "environment must be qa or prod"
  }
}


variable "region" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "bastion_eip_allocation_id" {
  type = string
}




variable "cidr_frontend" {
  type = string
}

variable "cidr_ms_a" {
  type = string
}

variable "cidr_ms_b" {
  type = string
}

variable "cidr_data" {
  type = string
}

variable "cidr_bastion" {
  type = string
}



variable "frontend_access_key" {
  type = string
}
variable "frontend_secret_key" {
  type = string
}

variable "ms_a_access_key" {
  type = string
}
variable "ms_a_secret_key" {
  type = string
}

variable "ms_b_access_key" {
  type = string
}
variable "ms_b_secret_key" {
  type = string
}

variable "data_access_key" {
  type = string
}
variable "data_secret_key" {
  type = string
}

variable "bastion_access_key" {
  type = string
}
variable "bastion_secret_key" {
  type = string
}



variable "frontend_session_token" {
  type = string
}

variable "ms_a_session_token" {
  type = string
}

variable "ms_b_session_token" {
  type = string
}

variable "data_session_token" {
  type = string
}

variable "bastion_session_token" {
  type = string
}


variable "key_name" {
  type = string
  default     = "prueba"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR range allowed for SSH to bastion"
  default     = "0.0.0.0/0"  # o el rango que quieras
}
