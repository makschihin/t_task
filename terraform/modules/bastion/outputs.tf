output "bastion_public_DNS" {
  value = aws_instance.bastion.public_dns
}

output "bastion_private_IP" {
    value = aws_instance.bastion.private_ip
}