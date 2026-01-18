# resource "cloudflare_record" "api" {
#   zone_id = var.cloudflare_zone_id
#   name    = "api"
#   value   = aws_eip.api_gateway.public_ip
#   type    = "A"
# }
