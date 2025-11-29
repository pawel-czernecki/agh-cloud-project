resource "aws_instance" "bastion" {
  ami           = var.bastion_ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name      = var.key_name
  tags = { Name = "bastion" }
}