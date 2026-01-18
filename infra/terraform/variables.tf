variable "env" {
  description = "qa or prod"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_accounts" {
  description = "AWS keys for each account"
  type = map(object({
    access_key    = string
    secret_key    = string
    session_token = string
  }))
}

variable "vpc_cidr_qa" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_cidr_prod" {
  type    = string
  default = "10.1.0.0/16"
}

variable "ami_id" {
  type        = string
  description = "AMI ID para Amazon Linux 2"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}
