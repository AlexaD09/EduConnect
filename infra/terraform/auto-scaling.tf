# Auto Scaling Groups solo para PROD
resource "aws_autoscaling_group" "frontend_web" {
  count                = var.env == "prod" ? 1 : 0
  provider             = aws.frontend
  name                 = "${var.env}-frontend-web-asg"
  max_size             = 2
  min_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [
    aws_subnet.frontend_public_a.id,
    aws_subnet.frontend_public_b.id
  ]
  target_group_arns    = var.env == "prod" ? [aws_lb_target_group.frontend[0].arn] : []
  launch_template {
    id      = aws_launch_template.frontend_web[0].id
    version = "$Latest"
  }
}

resource "aws_launch_template" "frontend_web" {
  count                    = var.env == "prod" ? 1 : 0
  provider                 = aws.frontend
  name                     = "${var.env}-frontend-web-lt"
  image_id                 = var.ami_id
  instance_type            = var.instance_type
  vpc_security_group_ids   = [aws_security_group.frontend.id]
  
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
docker run -d -p 80:80 nginx
EOF
  )
}