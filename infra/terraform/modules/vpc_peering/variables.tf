variable "name" {
  type = string
}

variable "requester_vpc_id" {
  type = string
}

variable "accepter_vpc_id" {
  type = string
}

variable "accepter_owner_id" {
  description = "AWS Account ID of the peer VPC owner. Required for cross-account VPC peering."
  type        = string
}

variable "peer_region" {
  description = "Peer VPC region (only required for cross-region peering)."
  type        = string
  default     = "us-east-1"
}

variable "requester_cidr" {
  type = string
}

variable "accepter_cidr" {
  type = string
}

variable "requester_route_table_id" {
  type = null
}

variable "accepter_route_table_id" {
  type = null
}

variable "requester_route_table_ids" {
  type    = list(string)
  default = []
}

variable "accepter_route_table_ids" {
  type    = list(string)
  default = []
}
