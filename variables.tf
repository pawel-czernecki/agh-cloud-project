variable "aws_region" {
    description = "AWS region to deploy resources"
    default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/26", "10.0.1.64/26"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.2.0/23", "10.0.4.0/23"]
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion host"
  default     = "ami-0fa3fe0fa7920f68e"
}

variable "ec2web_ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-0fa3fe0fa7920f68e"
}

variable "ec2web_instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access to the bastion host"
  default     = "kluczyk"
}

variable "admin_cidr" {
  description = "CIDR block for admin access to the bastion host"
  default     = "0.0.0.0/0"
}