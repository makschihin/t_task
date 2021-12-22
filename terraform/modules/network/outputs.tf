output "vpc_id" {
  value = aws_vpc.new_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "bastion_ip_addr" {
  value = aws_instance.bastion.public_ip
}

output "bastion_dns_addr" {
  value = aws_instance.bastion.public_dns
}