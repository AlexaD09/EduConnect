locals {
  docker_install = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    yum install -y docker-compose
  EOF
}

resource "aws_instance" "frontend" {
  provider = aws.frontend
  ami      = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.api.id
  vpc_security_group_ids = [aws_security_group.api.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    yum install -y docker-compose

    docker run -d --name frontend -p 80:80 ${var.frontend_image}
  EOF

  tags = { Name = "${var.env}-frontend" }
}

resource "aws_instance" "ms_a" {
  provider = aws.ms_a
  count    = length(var.microservices_ms_a)

  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.ms_a.id
  vpc_security_group_ids = [aws_security_group.internal_ms_a.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker

    docker run -d --name ms${count.index} -p 800${count.index}:8000 ${var.microservices_ms_a[count.index]}
  EOF

  tags = { Name = "${var.env}-ms-a-${count.index}" }
}

resource "aws_instance" "ms_b" {
  provider = aws.ms_b
  count    = length(var.microservices_ms_b)

  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.ms_b.id
  vpc_security_group_ids = [aws_security_group.internal_ms_b.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker

    docker run -d --name ms${count.index} -p 900${count.index}:8000 ${var.microservices_ms_b[count.index]}
  EOF

  tags = { Name = "${var.env}-ms-b-${count.index}" }
}

resource "aws_instance" "bastion" {
  provider = aws.bastion
  ami      = var.ami_id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.bastion.id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  user_data = local.docker_install

  tags = { Name = "${var.env}-bastion" }
}
