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
}