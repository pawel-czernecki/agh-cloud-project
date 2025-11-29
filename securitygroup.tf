resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.agh-cloud-project-vpc.id
  ingress { 
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.admin_cidr] 
  }
  egress { 
    from_port = 0 
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = { Name = "bastion-sg" }
}

resource "aws_security_group" "alb" {
    vpc_id = aws_vpc.agh-cloud-project-vpc.id
    ingress { 
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress { 
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    egress { 
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    tags = { Name = "alb-sg" }
}

resource "aws_security_group" "ec2web" {
  vpc_id = aws_vpc.agh-cloud-project-vpc.id
  ingress { 
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id] 
  }
  ingress { 
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id] 
  }
  ingress { 
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id] 
  }
  egress { 
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = { Name = "ec2web-sg" }
}

/*resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.agh-cloud-project-vpc.id
  ingress { 
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.ec2web.id] 
  }
  tags = { Name = "rds-sg" }
}*/