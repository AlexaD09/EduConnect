# Cloudflare (comentado hasta tener dominio)
/*
resource "cloudflare_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = "api"
  value   = var.env == "prod" ? 
    aws_lb.frontend[0].dns_name : 
    aws_instance.frontend_web_qa[0].public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_rate_limit" "api" {
  zone_id    = var.cloudflare_zone_id
  threshold  = 100
  period     = 60
  match {
    request {
      methods = ["_ALL_"]
      schemes = ["_ALL_"]
      url_pattern = "*"
    }
    response {
      statuses = [400, 401, 403, 429]
    }
  }
  action {
    mode = "simulate"
  }
}
*/