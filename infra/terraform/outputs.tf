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

output "ssh_private_key_pem" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
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
