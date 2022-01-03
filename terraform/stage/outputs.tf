output "bastion_public_DNS" {
  value = "${module.bastion.bastion_public_DNS}"
}

output "bastion_private_IP" {
  value = "${module.bastion.bastion_private_IP}"
}

output "websrv_private_IP" {
  value = "${module.websrv.websrv_private_IP}"
}