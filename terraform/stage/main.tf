provider "aws" {
  region = var.region
}

module "network" {
  source            = "../modules/network"
  enviroment        = var.enviroment
  vpc_cidr          = var.vpc_cidr
  public_subnet     = var.public_subnet
  private_subnet    = var.private_subnet
  region            = var.region
  availability_zone = var.availability_zone
  logname_bastion   = var.logname_bastion
  retention_bastion = var.retention_bastion
  kms_key_bastion   = var.kms_key_bastion
}

module "websrv" {
  source = "../modules/webserv"
  web_instance_count  = var.web_instance_count
  region              = var.region
  private_subnet_id   = "${module.network.private_subnet_id}"
  public_subnet_id    = "${module.network.public_subnet_id}"
  vpc_sg_id           = "${module.network.default_sg_id}"
  enviroment          = var.enviroment
  vpc_id              = "${module.network.vpc_id}"
  vpc_cidr            = var.vpc_cidr
  logname_websrv      = var.logname_websrv
  retention_websrv    = var.retention_websrv
  kms_key_websrv      = var.kms_key_websrv
}