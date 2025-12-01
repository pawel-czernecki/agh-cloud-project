resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 4
  min_size         = 2
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.tg.arn]
  health_check_type   = "EC2"
  health_check_grace_period = 30
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
  tags = { Name = "ec2-web-instance" }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    
    dnf update -y
    dnf install -y nginx php php-fpm php-cli git

    git clone https://github.com/pawel-czernecki/agh-cloud-project.git ~/app

    rm -fr /usr/share/nginx/html/*

    # multicloud approach ;) - pogoda service
    cat >/etc/nginx/conf.d/test.conf <<EOL
    server{

      listen 80;
      server_name _;

      location / {
        proxy_pass http://pogoda.testolearn.eu:8909/show.php;
      }
    }
    EOL

    rm /etc/nginx/nginx.conf
    cat >/etc/nginx/nginx.conf <<EOL
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log notice;
    pid /run/nginx.pid;

    # Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
    include /usr/share/nginx/modules/*.conf;

    events {
        worker_connections 1024;
    }

    http {
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile            on;
        tcp_nopush          on;
        keepalive_timeout   65;
        types_hash_max_size 4096;

        include             /etc/nginx/mime.types;
        default_type        application/octet-stream;

        # Load modular configuration files from the /etc/nginx/conf.d directory.
        # See http://nginx.org/en/docs/ngx_core_module.html#include
        # for more information.
        include /etc/nginx/conf.d/*.conf;
    }
    EOL

    mv ~/app/app/* /usr/share/nginx/html/

    chown -R nginx:nginx /usr/share/nginx/html
    chmod -R 755 /usr/share/nginx/html

    systemctl enable nginx
    systemctl enable php-fpm
    systemctl start php-fpm
    systemctl start nginx
  EOF
  )
}