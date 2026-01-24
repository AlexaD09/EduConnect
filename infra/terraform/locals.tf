locals {
  
  internal_cidrs = [
    var.cidr_bastion,
    var.cidr_frontend,
    var.cidr_ms_a,
    var.cidr_ms_b,
    var.cidr_data,
  ]
}
