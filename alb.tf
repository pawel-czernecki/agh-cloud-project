resource "aws_lb" "alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "tg" {
  name     = "app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.agh-cloud-project-vpc.id
  health_check { path = "/" }
}

resource "tls_private_key" "self_signed_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "self_signed_cert" {
  private_key_pem = tls_private_key.self_signed_key.private_key_pem

  subject {
    common_name  = "*.us-east-1.elb.amazonaws.com"  
    organization = "AGH Cloud Project"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self_signed_acm_cert" {
  certificate_body = tls_self_signed_cert.self_signed_cert.cert_pem
  private_key      = tls_private_key.self_signed_key.private_key_pem

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      validation_method,
    ]
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.self_signed_acm_cert.arn
  default_action { 
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.id 
  }
}