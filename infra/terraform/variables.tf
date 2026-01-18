variable "env" {
  description = "Environment (qa or prod)"
  type        = string
  default     = "qa"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "admin_cidr" {
  description = "Admin IP for Bastion access"
  type        = string
  default     = "0.0.0.0/0"
}