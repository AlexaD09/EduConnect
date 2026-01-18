resource "aws_instance" "notification_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_b[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8005:8000 alexa1209/notification-service:latest
EOF
  )
  tags = { Name = "${var.env}-notification-service" }
}

resource "aws_instance" "document_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_b[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8006:8000 alexa1209/document-service:latest
EOF
  )
  tags = { Name = "${var.env}-document-service" }
}

resource "aws_instance" "event_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_b[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8008:8000 alexa1209/event-service:latest
EOF
  )
  tags = { Name = "${var.env}-event-service" }
}

resource "aws_instance" "backup_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_b[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8009:8000 alexa1209/backup-service:latest
EOF
  )
  tags = { Name = "${var.env}-backup-service" }
}

resource "aws_instance" "evidence_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_b
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_b[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8010:8000 alexa1209/evidence-service:latest
EOF
  )
  tags = { Name = "${var.env}-evidence-service" }
} 