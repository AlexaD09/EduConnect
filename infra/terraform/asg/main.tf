resource "aws_launch_template" "prod" {
  image_id      = "AMI_ID"
  instance_type = "t3.micro"
  vpc_security_group_ids = [var.sg_app]

  user_data = base64encode(file("${path.module}/../ec2/userdata.sh"))
}

resource "aws_autoscaling_group" "prod" {
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  vpc_zone_identifier = var.private_subnets
  target_group_arns  = [var.target_group]

  launch_template {
    id      = aws_launch_template.prod.id
    version = "$Latest"
  }
}
