resource "aws_launch_template" "service_lt" {
  count         = var.account_type == "qa-service" || var.account_type == "prod-service" ? 1 : 0
  image_id      = "ami-0ac019f4fcb7e7741"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.service_sg[0].id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
apt update
apt install -y nginx
echo "${var.account_type} ${var.env} OK" > /var/www/html/index.html
systemctl start nginx
EOF
  )
}
