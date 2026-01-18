resource "aws_instance" "user_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_a[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8001:8000 alexa1209/user-service:latest
EOF
  )
  tags = { Name = "${var.env}-user-service" }
}

resource "aws_instance" "activity_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_a[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8002:8000 alexa1209/activity-service:latest
EOF
  )
  tags = { Name = "${var.env}-activity-service" }
}

resource "aws_instance" "agreement_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_a[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8003:8000 alexa1209/agreement-service:latest
EOF
  )
  tags = { Name = "${var.env}-agreement-service" }
}

resource "aws_instance" "approval_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_a[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8004:8000 alexa1209/approval-service:latest
EOF
  )
  tags = { Name = "${var.env}-approval-service" }
}

resource "aws_instance" "audit_service" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.ms_a
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ms_a[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8007:8000 alexa1209/audit-service:latest
EOF
  )
  tags = { Name = "${var.env}-audit-service" }
}