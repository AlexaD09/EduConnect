variable "name" {
  description = "Base name of the VPC (e.g., frontend-qa)"
  type        = string
}

variable "cidr_block" {
  description = "VPC's main CIDR"
  type        = string
}

variable "availability_zones" {
  description = "List of 2 AZs"
  type        = list(string)
}

variable "public_subnets_cidr" {
  description = "CIDR for public subnets (one per AZ)"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "CIDR for private subnets (one per AZ)"
  type        = list(string)
}

variable "enable_nat_instance" {
  description = "Create a NAT Instance to provide internet access from private subnets (without a NAT Gateway)."
  type        = bool
  default     = true
}

variable "nat_instance_type" {
  description = "Instance type for NAT Instance"
  type        = string
  default     = "t3.micro"
}

variable "nat_key_name" {
  description = "Key pair to manage the NAT Instance (optional)"
  type        = string
  default     = null
}

variable "admin_ssh_cidr" {
  description = "CIDR allowed for SSH to the NAT Instance (usually the CIDR of the Bastion VPC in the same environment)"
  type        = string
  default     = "0.0.0.0/0"
}
