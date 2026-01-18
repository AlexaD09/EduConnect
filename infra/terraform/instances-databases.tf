# Bases de datos
resource "aws_instance" "postgres" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.databases
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.databases.id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:15
EOF
  )
  tags = { Name = "${var.env}-postgres" }
}

resource "aws_instance" "redis" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.databases
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.databases.id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 6379:6379 redis:7
EOF
  )
  tags = { Name = "${var.env}-redis" }
}

resource "aws_instance" "kafka" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.databases
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.databases.id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 9092:9092 apache/kafka:3.7.1
EOF
  )
  tags = { Name = "${var.env}-kafka" }
}