resource "aws_instance" "frontend_web" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.frontend[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 80:80 alexa1209/frontend-web:latest
EOF
  )
  tags = { Name = "${var.env}-frontend-web" }
}

resource "aws_instance" "frontend_mobile" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.frontend[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 3001:80 alexa1209/frontend-mobile:latest
EOF
  )
  tags = { Name = "${var.env}-frontend-mobile" }
}

resource "aws_instance" "frontend_desktop" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.frontend[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 3002:80 alexa1209/frontend-desktop:latest
EOF
  )
  tags = { Name = "${var.env}-frontend-desktop" }
}

resource "aws_instance" "api_gateway" {
  count    = var.env == "qa" || var.env == "prod" ? 1 : 0
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.frontend[count.index].id]
  user_data_base64 = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker run -d -p 8000:80 nginx
EOF
  )
  tags = { Name = "${var.env}-api-gateway" }
}