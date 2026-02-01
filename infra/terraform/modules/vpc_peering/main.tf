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
  requester_rts = (
    length(var.requester_route_table_ids) > 0
    ? var.requester_route_table_ids
    : (var.requester_route_table_id == null ? [] : [var.requester_route_table_id])
  )

  accepter_rts = (
    length(var.accepter_route_table_ids) > 0
    ? var.accepter_route_table_ids
    : (var.accepter_route_table_id == null ? [] : [var.accepter_route_table_id])
  )
}



resource "aws_route" "requester_to_accepter" {
  for_each                 = toset(local.requester_rts)
  route_table_id            = each.value
  destination_cidr_block    = var.accepter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "accepter_to_requester" {
  provider                 = aws.peer
  for_each                 = toset(local.accepter_rts)
  route_table_id            = each.value
  destination_cidr_block    = var.requester_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}


