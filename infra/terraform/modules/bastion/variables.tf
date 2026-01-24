variable "name" {
  description = "Bastion name (ex: bastion-qa, bastion-prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the bastion is deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet where the bastion is deployed"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH access (e.g., admin's public IP address)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "key pair name for SSH"
  type        = string
}

variable "user_data" {
  description = "User data to install/configure NGINX (optional)"
  type        = string
  default     = null
}
