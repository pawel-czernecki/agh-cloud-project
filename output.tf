output "bastion_instance_ip" {
  value = {
    public_ip = aws_instance.bastion.public_ip
    private_ip = aws_instance.bastion.private_ip
  }
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}