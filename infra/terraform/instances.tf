##############################################
# FRONTEND
##############################################

resource "aws_instance" "frontend_web" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.frontend
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 80:80 alexa1209/frontend-web:latest
EOF
  )

  tags = { Name = "${var.env}-frontend-web" }
}

resource "aws_instance" "frontend_mobile" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.frontend
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 3001:80 alexa1209/frontend-mobile:latest
EOF
  )

  tags = { Name = "${var.env}-frontend-mobile" }
}

resource "aws_instance" "frontend_desktop" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.frontend
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 3002:80 alexa1209/frontend-desktop:latest
EOF
  )

  tags = { Name = "${var.env}-frontend-desktop" }
}

resource "aws_instance" "api_gateway" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.frontend
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8000:80 nginx
EOF
  )

  tags = { Name = "${var.env}-api-gateway" }
}

##############################################
# MICROSERVICIOS A (1-5)
##############################################

resource "aws_instance" "user_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_a
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_a.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8001:8000 alexa1209/user-service:latest
EOF
  )

  tags = { Name = "${var.env}-user-service" }
}

resource "aws_instance" "activity_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_a
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_a.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8002:8000 alexa1209/activity-service:latest
EOF
  )

  tags = { Name = "${var.env}-activity-service" }
}

resource "aws_instance" "agreement_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_a
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_a.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8003:8000 alexa1209/agreement-service:latest
EOF
  )

  tags = { Name = "${var.env}-agreement-service" }
}

resource "aws_instance" "approval_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_a
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_a.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8004:8000 alexa1209/approval-service:latest
EOF
  )

  tags = { Name = "${var.env}-approval-service" }
}

resource "aws_instance" "audit_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_a
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_a.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8007:8000 alexa1209/audit-service:latest
EOF
  )

  tags = { Name = "${var.env}-audit-service" }
}

##############################################
# MICROSERVICIOS B (6-10)
##############################################

resource "aws_instance" "notification_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_b
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_b.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8005:8000 alexa1209/notification-service:latest
EOF
  )

  tags = { Name = "${var.env}-notification-service" }
}

resource "aws_instance" "document_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_b
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_b.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8006:8000 alexa1209/document-service:latest
EOF
  )

  tags = { Name = "${var.env}-document-service" }
}

resource "aws_instance" "event_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_b
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_b.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8008:8000 alexa1209/event-service:latest
EOF
  )

  tags = { Name = "${var.env}-event-service" }
}

resource "aws_instance" "backup_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_b
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_b.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8009:8000 alexa1209/backup-service:latest
EOF
  )

  tags = { Name = "${var.env}-backup-service" }
}

resource "aws_instance" "evidence_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.ms_b
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_b.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 8010:8000 alexa1209/evidence-service:latest
EOF
  )

  tags = { Name = "${var.env}-evidence-service" }
}

##############################################
# BASES DE DATOS
##############################################

resource "aws_instance" "postgres" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.databases
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.databases_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_databases.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:15
EOF
  )

  tags = { Name = "${var.env}-postgres" }
}

resource "aws_instance" "redis" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.databases
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.databases_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_databases.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 6379:6379 redis:7
EOF
  )

  tags = { Name = "${var.env}-redis" }
}

resource "aws_instance" "kafka" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider               = aws.databases
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.databases_private_a.id
  vpc_security_group_ids = [aws_security_group.internal_databases.id]

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
docker run -d -p 9092:9092 apache/kafka:3.7.1
EOF
  )

  tags = { Name = "${var.env}-kafka" }
}

##############################################
# BASTION HOST
##############################################

resource "aws_instance" "bastion" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.bastion
  ami      = var.ami_id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.bastion_public_a.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = { Name = "${var.env}-bastion" }
}