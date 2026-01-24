variable "name" {
  description = "ALB base name (e.g., ms-a-prod)"
  type        = string
}

variable "environment" {
  description = "Environment (QA or production)"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the ALB and the ASG live"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets (minimum 2)"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for each microservice (ASG)"
  type        = string
}

variable "key_name" {
  description = "KeyPair for SSH"
  type        = string
}

variable "bastion_cidr" {
  description = "CIDR of the Bastion VPC in the same environment"
  type        = string
}

variable "services" {
  description = "Map: service_name => path_prefix (e.g., { user = "/user" })"
  type        = map(string)
}

variable "service_port" {
  description = "Port where each microservice listens"
  type        = number
  default     = 8000
}

variable "user_data" {
  description = "User data to start the microservice docker (completed in Module 2)"
  type        = string
  default     = null
}
