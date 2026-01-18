# Frontend instances (Web, Mobile, Desktop, API Gateway)
resource "aws_instance" "frontend_web" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 80:80 alexa1209/frontend-web:latest
EOF
  )
}

resource "aws_instance" "frontend_mobile" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 3001:80 alexa1209/frontend-mobile:latest
EOF
  )
}

resource "aws_instance" "frontend_desktop" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 3002:80 alexa1209/frontend-desktop:latest
EOF
  )
}

resource "aws_instance" "api_gateway" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.frontend_public_a.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8000:80 nginx
EOF
  )
}

# Microservicios A (1-5)
resource "aws_instance" "ms_a_user" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8001:8000 alexa1209/user-service:latest
EOF
  )
}

resource "aws_instance" "ms_a_activity" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8002:8000 alexa1209/activity-service:latest
EOF
  )
}

resource "aws_instance" "ms_a_agreement" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8003:8000 alexa1209/agreement-service:latest
EOF
  )
}

resource "aws_instance" "ms_a_approval" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8004:8000 alexa1209/approval-service:latest
EOF
  )
}

resource "aws_instance" "ms_a_audit" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_a_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8007:8000 alexa1209/audit-service:latest
EOF
  )
}

# Microservicios B (6-10)
resource "aws_instance" "ms_b_notification" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8005:8000 alexa1209/notification-service:latest
EOF
  )
}

resource "aws_instance" "ms_b_document" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8006:8000 alexa1209/document-service:latest
EOF
  )
}

resource "aws_instance" "ms_b_event" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8008:8000 alexa1209/event-service:latest
EOF
  )
}

resource "aws_instance" "ms_b_backup" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8009:8000 alexa1209/backup-service:latest
EOF
  )
}

resource "aws_instance" "ms_b_evidence" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.ms_b_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 8010:8000 alexa1209/evidence-service:latest
EOF
  )
}

# Bases de datos
resource "aws_instance" "postgres" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.databases
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.databases_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:15
EOF
  )
}

resource "aws_instance" "redis" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.databases
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.databases_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 6379:6379 redis:7
EOF
  )
}

resource "aws_instance" "kafka" {
  count    = var.env == "qa" ? 1 : 0
  provider = aws.databases
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.databases_private_a.id
  vpc_security_group_ids = [aws_security_group.internal.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 9092:9092 apache/kafka:3.7.1
EOF
  )
}

# Bastion Host
resource "aws_instance" "bastion" {
  count    = 1
  provider = aws.bastion
  ami      = var.ami_id
  instance_type = "t3.micro"
  subnet_id = var.env == "qa" ? aws_subnet.bastion_public_a.id : aws_subnet.bastion_public_a.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
}