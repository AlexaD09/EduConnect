variable "env" {
  type    = string
  default = "qa"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_accounts" {
  type = map(object({
    access_key    = string
    secret_key    = string
    session_token = string
  }))
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
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

variable "vpc_cidr_qa" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_cidr_prod" {
  type    = string
  default = "10.10.0.0/16"
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0" # Cambiar a tu IP real en producción
}