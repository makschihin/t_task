output "websrv_private_IP" {
  value = aws_instance.websrv[*].private_ip
}