resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  peer_owner_id = var.accepter_owner_id
  peer_region   = var.peer_region
  auto_accept = false

  tags = {
    Name = var.name
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = true

  tags = {
    Name = var.name
  }
}

locals {
  requester_rt_map = { for idx, rt_id in var.requester_route_table_ids : tostring(idx) => rt_id }
  accepter_rt_map  = { for idx, rt_id in var.accepter_route_table_ids  : tostring(idx) => rt_id }
}

resource "aws_route" "requester_to_accepter" {
  for_each                  = local.requester_rt_map
  route_table_id            = each.value
  destination_cidr_block    = var.accepter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

}

resource "aws_route" "accepter_to_requester" {
  provider                  = aws.peer
  for_each                  = local.accepter_rt_map
  route_table_id            = each.value
  destination_cidr_block    = var.requester_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

}



