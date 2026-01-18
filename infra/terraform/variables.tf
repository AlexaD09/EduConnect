variable "env" {
  description = "Environment (qa or prod)"
  type        = string
  default     = "qa"
}

variable "use_default_vpc" {
  description = "Use default VPC (for AWS Academy)"
  type        = bool
  default     = true
}


variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "microservices_ms_a" {
  type    = list(string)
  default = [
    "alexa1209/user-service",
    "alexa1209/activity-service", 
    "alexa1209/agreement-service",
    "alexa1209/approval-service",
    "alexa1209/audit-service"
  ]
}

variable "microservices_ms_b" {
  type    = list(string)
  default = [
    "alexa1209/notification-service",
    "alexa1209/document-service",
    "alexa1209/event-service", 
    "alexa1209/backup-service",
    "alexa1209/evidence-service"
  ]
}

variable "frontend_images" {
  type    = list(string)
  default = [
    "alexa1209/frontend-web",
    "alexa1209/frontend-mobile",
    "alexa1209/frontend-desktop",
    "alexa1209/api-gateway"
  ]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "vpc_cidr" {
  description = "VPC CIDR by environment"
  type        = map(string)
  default = {
    qa   = "10.0.0.0/16"
    prod = "10.1.0.0/16"
  }
}

variable "admin_cidr" {
  description = "Admin IP for Bastion access"
  type        = string
  default     = "0.0.0.0/0"
}