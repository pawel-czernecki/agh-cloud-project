resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 4
  min_size         = 2
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.tg.arn]
  health_check_type   = "EC2"
  health_check_grace_period = 10
  launch_template { 
    id = aws_launch_template.ec2_web.id 
    version = "$Latest"
  }
}

resource "aws_launch_template" "ec2_web" {
  name_prefix   = "app-"
  image_id      = var.ec2web_ami_id
  instance_type = var.ec2web_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2web.id]
  tags = { 
    Name = "ec2-web-instance" 
  }
  user_data = base64encode(data.template_file.deploy.rendered)

  iam_instance_profile {
    name = "LabInstanceProfile"
  }

  depends_on = [
    aws_db_instance.rds,
    aws_secretsmanager_secret.db
  ]
} 

data "template_file" "deploy" {
  template = file("deploy.sh.tpl")

  vars = {
    db_name   = aws_db_instance.rds.db_name
    db_host   = aws_db_instance.rds.address
    db_port   = aws_db_instance.rds.port
    secret_id = aws_secretsmanager_secret.db.name
  }
}