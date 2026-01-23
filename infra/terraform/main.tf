

data "aws_caller_identity" "frontend" {
  provider = aws.frontend
}

data "aws_caller_identity" "microservices_a" {
  provider = aws.microservices_a
}

data "aws_caller_identity" "microservices_b" {
  provider = aws.microservices_b
}

data "aws_caller_identity" "data" {
  provider = aws.data
}

data "aws_caller_identity" "bastion" {
  provider = aws.bastion
}

module "vpc_frontend" {
  source = "./modules/vpc"
  providers = { aws = aws.frontend }

  name       = "frontend-${var.environment}"
  cidr_block = var.cidr_frontend

  availability_zones = var.availability_zones

  public_subnets_cidr = [
    cidrsubnet(var.cidr_frontend, 8, 0),
    cidrsubnet(var.cidr_frontend, 8, 1)
  ]

  private_subnets_cidr = [
    cidrsubnet(var.cidr_frontend, 8, 10),
    cidrsubnet(var.cidr_frontend, 8, 11)
  ]

  
  enable_nat_instance = true
  nat_key_name        = aws_key_pair.frontend.key_name
  admin_ssh_cidr      = var.cidr_bastion
}


module "vpc_ms_a" {
  source = "./modules/vpc"
  providers = { aws = aws.microservices_a }

  name       = "ms-a-${var.environment}"
  cidr_block = var.cidr_ms_a

  availability_zones = var.availability_zones

  public_subnets_cidr = [
    cidrsubnet(var.cidr_ms_a, 8, 0),
    cidrsubnet(var.cidr_ms_a, 8, 1)
  ]

  private_subnets_cidr = [
    cidrsubnet(var.cidr_ms_a, 8, 10),
    cidrsubnet(var.cidr_ms_a, 8, 11)
  ]

  enable_nat_instance = true
  nat_key_name        = aws_key_pair.microservices_a.key_name
  admin_ssh_cidr      = var.cidr_bastion
}


module "vpc_ms_b" {
  source = "./modules/vpc"
  providers = { aws = aws.microservices_b }

  name       = "ms-b-${var.environment}"
  cidr_block = var.cidr_ms_b

  availability_zones = var.availability_zones

  public_subnets_cidr = [
    cidrsubnet(var.cidr_ms_b, 8, 0),
    cidrsubnet(var.cidr_ms_b, 8, 1)
  ]

  private_subnets_cidr = [
    cidrsubnet(var.cidr_ms_b, 8, 10),
    cidrsubnet(var.cidr_ms_b, 8, 11)
  ]

  enable_nat_instance = true
  nat_instance_type = "t3.micro"

  nat_key_name        = aws_key_pair.microservices_b.key_name
  admin_ssh_cidr      = var.cidr_bastion
}

module "vpc_data" {
  source = "./modules/vpc"
  providers = { aws = aws.data }

  name       = "data-${var.environment}"
  cidr_block = var.cidr_data

  availability_zones = var.availability_zones

  public_subnets_cidr = [
    cidrsubnet(var.cidr_data, 8, 0),
    cidrsubnet(var.cidr_data, 8, 1)
  ]

  private_subnets_cidr = [
    cidrsubnet(var.cidr_data, 8, 10),
    cidrsubnet(var.cidr_data, 8, 11)
  ]

  enable_nat_instance = true
  nat_key_name        = aws_key_pair.data.key_name
  admin_ssh_cidr      = var.cidr_bastion
}


module "vpc_bastion" {
  source = "./modules/vpc"
  providers = { aws = aws.bastion }

  name       = "bastion-${var.environment}"
  cidr_block = var.cidr_bastion

  availability_zones = var.availability_zones

  public_subnets_cidr = [
    cidrsubnet(var.cidr_bastion, 8, 0),
    cidrsubnet(var.cidr_bastion, 8, 1)
  ]

  private_subnets_cidr = [
    cidrsubnet(var.cidr_bastion, 8, 10),
    cidrsubnet(var.cidr_bastion, 8, 11)
  ]

  
  enable_nat_instance = false
}






module "bastion" {
  source    = "./modules/bastion"
  providers = { aws = aws.bastion }

  name              = "bastion-${var.environment}"
  vpc_id            = module.vpc_bastion.vpc_id
  public_subnet_id = module.vpc_bastion.public_subnet_ids[0] 
  allowed_ssh_cidr = var.allowed_ssh_cidr 
  instance_type     = "t3.micro"
  key_name = aws_key_pair.bastion.key_name

  
  user_data = <<-EOF
              #!/bin/bash
              set -eux
              yum -y update
              amazon-linux-extras install -y nginx1 || yum -y install nginx
              systemctl enable nginx
              cat > /usr/share/nginx/html/index.html <<'HTML'
              <html><body>
              <h1>Academic Linkage Platform - ${var.environment}</h1>
              <p>Bastion/API Gateway listo (NGINX). Proximo modulo: reverse proxy a microservicios.</p>
              </body></html>
              HTML
              systemctl start nginx
              EOF
}






module "frontend_web" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.frontend }

  name             = "frontend-web-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.frontend.key_name
  allowed_app_port = 80

  vpc_id         = module.vpc_frontend.vpc_id
  subnet_ids     = module.vpc_frontend.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs

  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "frontend_mobile" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.frontend }

  name             = "frontend-mobile-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.frontend.key_name
  allowed_app_port = 80

  vpc_id         = module.vpc_frontend.vpc_id
  subnet_ids     = module.vpc_frontend.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs

  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "frontend_desktop" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.frontend }

  name             = "frontend-desktop-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.frontend.key_name
  allowed_app_port = 80

  vpc_id         = module.vpc_frontend.vpc_id
  subnet_ids     = module.vpc_frontend.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs

  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}






module "ms_activity_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_a }

  name             = "activity-service-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_a.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_a.vpc_id
  subnet_ids     = module.vpc_ms_a.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_agreement_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_a }

  name             = "agreement-service-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_a.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_a.vpc_id
  subnet_ids     = module.vpc_ms_a.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_api_gateway" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_a }

  name             = "api-gateway-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_a.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_a.vpc_id
  subnet_ids     = module.vpc_ms_a.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_user_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_a }

  name             = "user-service-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_a.key_name
  allowed_app_port = 8000

  vpc_id            = module.vpc_ms_a.vpc_id
  subnet_ids        = module.vpc_ms_a.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr      = var.cidr_bastion
  instance_count    = 1
}

module "ms_approval_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_a }

  name             = "approval-service-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_a.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_a.vpc_id
  subnet_ids     = module.vpc_ms_a.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_audit_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_a }

  name             = "audit-service-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_a.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_a.vpc_id
  subnet_ids     = module.vpc_ms_a.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}




module "ms_backup_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_b }

  name             = "backup-service-${var.environment}"
  instance_type = "t2.micro"
  key_name         = aws_key_pair.microservices_b.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_b.vpc_id
  subnet_ids     = module.vpc_ms_b.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_document_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_b }

  name             = "document-service-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_b.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_b.vpc_id
  subnet_ids     = module.vpc_ms_b.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_event_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_b }

  name             = "event-service-${var.environment}"
  instance_type = "t2.micro"
  key_name         = aws_key_pair.microservices_b.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_b.vpc_id
  subnet_ids     = module.vpc_ms_b.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_evidence_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_b }

  name             = "evidence-service-${var.environment}"
  instance_type = "t2.micro"
  key_name         = aws_key_pair.microservices_b.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_b.vpc_id
  subnet_ids     = module.vpc_ms_b.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "ms_notification_service" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.microservices_b }

  name             = "notification-service-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.microservices_b.key_name
  allowed_app_port = 8000

  vpc_id         = module.vpc_ms_b.vpc_id
  subnet_ids     = module.vpc_ms_b.private_subnet_ids
  allowed_app_cidrs = local.internal_cidrs
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}





module "data_postgres" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.data }

  name             = "postgres-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.data.key_name
  allowed_app_port = 5432

  vpc_id         = module.vpc_data.vpc_id
  subnet_ids     = module.vpc_data.private_subnet_ids

  
  allowed_app_cidrs = [var.cidr_ms_a, var.cidr_ms_b]

  
  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "data_redis" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.data }

  name             = "redis-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.data.key_name
  allowed_app_port = 6379

  vpc_id         = module.vpc_data.vpc_id
  subnet_ids     = module.vpc_data.private_subnet_ids
  allowed_app_cidrs = [var.cidr_ms_a, var.cidr_ms_b]

  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}

module "data_kafka" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.data }

  name             = "kafka-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.data.key_name
  allowed_app_port = 9092

  vpc_id         = module.vpc_data.vpc_id
  subnet_ids     = module.vpc_data.private_subnet_ids
  allowed_app_cidrs = [var.cidr_ms_a, var.cidr_ms_b]

  bastion_cidr   = var.cidr_bastion
  instance_count = 1
}


module "data_mongo" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.data }

  name             = "mongo-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.data.key_name
  allowed_app_port = 27017

  vpc_id            = module.vpc_data.vpc_id
  subnet_ids        = module.vpc_data.private_subnet_ids
  allowed_app_cidrs = [var.cidr_ms_a, var.cidr_ms_b]
  bastion_cidr      = var.cidr_bastion
  instance_count    = 1
}

module "data_rabbitmq" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.data }

  name             = "rabbitmq-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.data.key_name
  allowed_app_port = 5672

  vpc_id            = module.vpc_data.vpc_id
  subnet_ids        = module.vpc_data.private_subnet_ids
  allowed_app_cidrs = [var.cidr_ms_a, var.cidr_ms_b]
  bastion_cidr      = var.cidr_bastion
  instance_count    = 1
}

module "data_mqtt" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.data }

  name             = "mqtt-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.data.key_name
  allowed_app_port = 1883

  vpc_id            = module.vpc_data.vpc_id
  subnet_ids        = module.vpc_data.private_subnet_ids
  allowed_app_cidrs = [var.cidr_ms_a, var.cidr_ms_b]
  bastion_cidr      = var.cidr_bastion
  instance_count    = 1
}

module "data_n8n" {
  source    = "./modules/microservice_ec2"
  providers = { aws = aws.data }

  name             = "n8n-${var.environment}"
  instance_type    = "t3.micro"
  key_name         = aws_key_pair.data.key_name
  allowed_app_port = 5678

  vpc_id            = module.vpc_data.vpc_id
  subnet_ids        = module.vpc_data.private_subnet_ids
  allowed_app_cidrs = [var.cidr_ms_a, var.cidr_ms_b]
  bastion_cidr      = var.cidr_bastion
  instance_count    = 1
}




module "prod_ms_a_activity_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_a }
  count     = var.environment == "prod" ? 1 : 0

  name                = "ms-a-activity-${var.environment}"
  environment         = var.environment
  vpc_id              = module.vpc_ms_a.vpc_id
  public_subnet_ids   = module.vpc_ms_a.private_subnet_ids
  private_subnet_ids  = module.vpc_ms_a.private_subnet_ids
  instance_type       = "t3.micro"
  key_name            = aws_key_pair.microservices_a.key_name
  allowed_http_cidr   = var.cidr_bastion
  bastion_cidr        = var.cidr_bastion
  internal            = true
}

module "prod_ms_a_agreement_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_a }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-a-agreement-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_a.vpc_id
  public_subnet_ids  = module.vpc_ms_a.private_subnet_ids
  private_subnet_ids = module.vpc_ms_a.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_a.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_a_apigw_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_a }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-a-apigw-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_a.vpc_id
  public_subnet_ids  = module.vpc_ms_a.private_subnet_ids
  private_subnet_ids = module.vpc_ms_a.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_a.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_a_approval_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_a }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-a-approval-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_a.vpc_id
  public_subnet_ids  = module.vpc_ms_a.private_subnet_ids
  private_subnet_ids = module.vpc_ms_a.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_a.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_a_audit_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_a }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-a-audit-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_a.vpc_id
  public_subnet_ids  = module.vpc_ms_a.private_subnet_ids
  private_subnet_ids = module.vpc_ms_a.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_a.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_b_backup_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-b-backup-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_b_document_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-b-document-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_b_event_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-b-event-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_b_evidence_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-b-evidence-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_ms_b_notification_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name               = "ms-b-notification-${var.environment}"
  environment        = var.environment
  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name
  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
  internal           = true
}

module "prod_audit_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_a }
  count     = var.environment == "prod" ? 1 : 0

  name            = "audit-${var.environment}"
  environment     = var.environment
  internal        = true

  vpc_id             = module.vpc_ms_a.vpc_id
  public_subnet_ids  = module.vpc_ms_a.private_subnet_ids
  private_subnet_ids = module.vpc_ms_a.private_subnet_ids

  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_a.key_name

  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
}




module "prod_backup_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name            = "backup-${var.environment}"
  environment     = var.environment
  internal        = true

  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids

  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name

  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
}

module "prod_document_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name            = "document-${var.environment}"
  environment     = var.environment
  internal        = true

  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids

  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name

  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
}

module "prod_event_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name            = "event-${var.environment}"
  environment     = var.environment
  internal        = true

  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids

  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name

  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
}

module "prod_evidence_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name            = "evidence-${var.environment}"
  environment     = var.environment
  internal        = true

  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids

  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name

  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
}

module "prod_notification_alb_asg" {
  source    = "./modules/alb_asg"
  providers = { aws = aws.microservices_b }
  count     = var.environment == "prod" ? 1 : 0

  name            = "notification-${var.environment}"
  environment     = var.environment
  internal        = true

  vpc_id             = module.vpc_ms_b.vpc_id
  public_subnet_ids  = module.vpc_ms_b.private_subnet_ids
  private_subnet_ids = module.vpc_ms_b.private_subnet_ids

  instance_type      = "t3.micro"
  key_name           = aws_key_pair.microservices_b.key_name

  allowed_http_cidr  = var.cidr_bastion
  bastion_cidr       = var.cidr_bastion
}







module "peer_frontend_ms_a" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.frontend
    aws.peer = aws.microservices_a
  }

  name = "peer-frontend-ms-a-${var.environment}"

  requester_vpc_id = module.vpc_frontend.vpc_id
  accepter_vpc_id  = module.vpc_ms_a.vpc_id
  accepter_owner_id = data.aws_caller_identity.microservices_a.account_id

  requester_cidr = var.cidr_frontend
  accepter_cidr  = var.cidr_ms_a

  requester_route_table_id = module.vpc_frontend.private_route_table_id
  accepter_route_table_id  = module.vpc_ms_a.private_route_table_id

   depends_on = [
    module.vpc_frontend,
    module.vpc_ms_a
  ]
}


module "peer_frontend_ms_b" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.frontend
    aws.peer = aws.microservices_b
  }

  name = "peer-frontend-ms-b-${var.environment}"

  requester_vpc_id = module.vpc_frontend.vpc_id
  accepter_vpc_id  = module.vpc_ms_b.vpc_id
  accepter_owner_id = data.aws_caller_identity.microservices_b.account_id

  requester_cidr = var.cidr_frontend
  accepter_cidr  = var.cidr_ms_b

  requester_route_table_id = module.vpc_frontend.private_route_table_id
  accepter_route_table_id  = module.vpc_ms_b.private_route_table_id

   depends_on = [
    module.vpc_frontend,
    module.vpc_ms_b
  ]
}


module "peer_ms_a_data" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.microservices_a
    aws.peer = aws.data
  }

  name = "peer-ms-a-data-${var.environment}"

  requester_vpc_id = module.vpc_ms_a.vpc_id
  accepter_vpc_id  = module.vpc_data.vpc_id
  accepter_owner_id = data.aws_caller_identity.data.account_id

  requester_cidr = var.cidr_ms_a
  accepter_cidr  = var.cidr_data

  requester_route_table_id = module.vpc_ms_a.private_route_table_id
  accepter_route_table_id  = module.vpc_data.private_route_table_id
   depends_on = [
    module.vpc_ms_a,
    module.vpc_data
  ]
}


module "peer_ms_b_data" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.microservices_b
    aws.peer = aws.data
  }

  name = "peer-ms-b-data-${var.environment}"

  requester_vpc_id = module.vpc_ms_b.vpc_id
  accepter_vpc_id  = module.vpc_data.vpc_id
  accepter_owner_id = data.aws_caller_identity.data.account_id

  requester_cidr = var.cidr_ms_b
  accepter_cidr  = var.cidr_data

  requester_route_table_id = module.vpc_ms_b.private_route_table_id
  accepter_route_table_id  = module.vpc_data.private_route_table_id
   depends_on = [
    module.vpc_ms_b,
    module.vpc_data
  ]
}


module "peer_bastion_frontend" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.bastion
    aws.peer = aws.frontend
  }

  name = "peer-bastion-frontend-${var.environment}"

  requester_vpc_id = module.vpc_bastion.vpc_id
  accepter_vpc_id  = module.vpc_frontend.vpc_id
  accepter_owner_id = data.aws_caller_identity.frontend.account_id

  requester_cidr = var.cidr_bastion
  accepter_cidr  = var.cidr_frontend

  requester_route_table_id = module.vpc_bastion.private_route_table_id
  accepter_route_table_id  = module.vpc_frontend.private_route_table_id

   depends_on = [
    module.vpc_frontend,
    module.vpc_bastion
  ]
}


module "peer_bastion_ms_a" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.bastion
    aws.peer = aws.microservices_a
  }

  name = "peer-bastion-ms-a-${var.environment}"

  requester_vpc_id = module.vpc_bastion.vpc_id
  accepter_vpc_id  = module.vpc_ms_a.vpc_id
  accepter_owner_id = data.aws_caller_identity.microservices_a.account_id

  requester_cidr = var.cidr_bastion
  accepter_cidr  = var.cidr_ms_a

  requester_route_table_id = module.vpc_bastion.private_route_table_id
  accepter_route_table_id  = module.vpc_ms_a.private_route_table_id

   depends_on = [
    module.vpc_bastion,
    module.vpc_ms_a
  ]
}


module "peer_bastion_ms_b" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.bastion
    aws.peer = aws.microservices_b

  }

  name = "peer-bastion-ms-b-${var.environment}"

  requester_vpc_id = module.vpc_bastion.vpc_id
  accepter_vpc_id  = module.vpc_ms_b.vpc_id
  accepter_owner_id = data.aws_caller_identity.microservices_b.account_id

  requester_cidr = var.cidr_bastion
  accepter_cidr  = var.cidr_ms_b

  requester_route_table_id = module.vpc_bastion.private_route_table_id
  accepter_route_table_id  = module.vpc_ms_b.private_route_table_id

   depends_on = [
    module.vpc_bastion,
    module.vpc_ms_b
  ]
}


module "peer_bastion_data" {
  source = "./modules/vpc_peering"
  providers = {
    aws      = aws.bastion
    aws.peer = aws.data
  }

  name = "peer-bastion-data-${var.environment}"

  requester_vpc_id = module.vpc_bastion.vpc_id
  accepter_vpc_id  = module.vpc_data.vpc_id
  accepter_owner_id = data.aws_caller_identity.data.account_id

  requester_cidr = var.cidr_bastion
  accepter_cidr  = var.cidr_data

  requester_route_table_id = module.vpc_bastion.private_route_table_id
  accepter_route_table_id  = module.vpc_data.private_route_table_id

   depends_on = [
    module.vpc_bastion,
    module.vpc_data
  ]
}
