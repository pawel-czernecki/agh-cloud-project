resource "aws_vpc" "agh-cloud-project-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "agh-cloud-project-vpc"
  }
}