resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 4
  min_size         = 2
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.tg.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300
  launch_template { id = aws_launch_template.ec2_web.id }
}

resource "aws_launch_template" "ec2_web" {
  name_prefix   = "app-"
  image_id      = var.ec2web_ami_id
  instance_type = var.ec2web_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2web.id]
  tags = { Name = "ec2-web-instance" }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    
    dnf update -y
    dnf install -y nginx php php-fpm php-cli git

    chown -R nginx:nginx /usr/share/nginx/html
    chmod -R 755 /usr/share/nginx/html

    systemctl enable nginx
    systemctl enable php-fpm
    systemctl start php-fpm
    systemctl start nginx
  EOF
  )
}