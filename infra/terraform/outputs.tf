output "environment" {
  value = var.environment
}


data "aws_eip" "bastion" {
  id = var.bastion_eip_allocation_id
}


output "bastion_public_ip" {
  value = data.aws_eip.bastion.public_ip
}

output "frontend_web_private_ip" {
  value = module.frontend_web.private_ips[0]
}

output "api_gateway_private_ip" {
  value = module.ms_api_gateway.private_ips[0]
}




output "activity_private_ip"  { value = module.ms_activity_service.private_ips[0] }
output "agreement_private_ip" { value = module.ms_agreement_service.private_ips[0] }
output "approval_private_ip"  { value = module.ms_approval_service.private_ips[0] }
output "audit_private_ip"     { value = module.ms_audit_service.private_ips[0] }
output "user_private_ip" { value = module.ms_user_service.private_ips[0] }



output "backup_private_ip"        { value = module.ms_backup_service.private_ips[0] }
output "document_private_ip"      { value = module.ms_document_service.private_ips[0] }
output "event_private_ip"         { value = module.ms_event_service.private_ips[0] }
output "evidence_private_ip"      { value = module.ms_evidence_service.private_ips[0] }
output "notification_private_ip"  { value = module.ms_notification_service.private_ips[0] }


output "postgres_private_ip" { value = module.data_postgres.private_ips[0] }
output "redis_private_ip"    { value = module.data_redis.private_ips[0] }
output "kafka_private_ip"    { value = module.data_kafka.private_ips[0] }
output "mongo_private_ip"    { value = module.data_mongo.private_ips[0] }
output "rabbit_private_ip"   { value = module.data_rabbitmq.private_ips[0] }
output "mqtt_private_ip"     { value = module.data_mqtt.private_ips[0] }
output "n8n_private_ip"      { value = module.data_n8n.private_ips[0] }
output "api_gateway_public_ip" {
  value = module.ms_api_gateway.public_ips[0]
}

output "api_gateway_public_url" {
  value = "http://${module.ms_api_gateway.public_ips[0]}:8000"
}

 
output "service_endpoints" {
  value = {
    "frontend-web"        = { ip = module.frontend_web.private_ips[0],            port = 80 }
    "api-gateway"         = { ip = module.ms_api_gateway.private_ips[0],          port = 80 }

    "activity-service"    = { ip = module.ms_activity_service.private_ips[0],     port = 8000 }
    "agreement-service"   = { ip = module.ms_agreement_service.private_ips[0],    port = 8000 }
    "approval-service"    = { ip = module.ms_approval_service.private_ips[0],     port = 8000 }
    "audit-service"       = { ip = module.ms_audit_service.private_ips[0],        port = 8000 }
    "user-service"        = { ip = module.ms_user_service.private_ips[0],         port = 8000 }

    "backup-service"      = { ip = module.ms_backup_service.private_ips[0],       port = 8000 }
    "document-service"    = { ip = module.ms_document_service.private_ips[0],     port = 8000 }
    "event-service"       = { ip = module.ms_event_service.private_ips[0],        port = 8000 }
    "evidence-service"    = { ip = module.ms_evidence_service.private_ips[0],     port = 8000 }
    "notification-service"= { ip = module.ms_notification_service.private_ips[0], port = 8000 }

    "postgres"            = { ip = module.data_postgres.private_ips[0],           port = 5432 }
    "redis"               = { ip = module.data_redis.private_ips[0],              port = 6379 }
    "kafka"               = { ip = module.data_kafka.private_ips[0],              port = 9092 }
    "mongo"               = { ip = module.data_mongo.private_ips[0],              port = 27017 }
    "rabbitmq"            = { ip = module.data_rabbitmq.private_ips[0],           port = 5672 }
    "mqtt"                = { ip = module.data_mqtt.private_ips[0],               port = 1883 }
    "n8n"                 = { ip = module.data_n8n.private_ips[0],                port = 5678 }
  }
}
