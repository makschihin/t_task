variable "vpc_cidr" {
  description = "The CIDR block of new VPC"
}

variable "vpc_id" {
  description = "The id of the vpc"
}

variable "enviroment" {
  description = "The enviroment"
}

variable "region" {
  description = "The region to launch hosts"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "public_key_path" {
  description = "Public key path for SSH to the instance"
  type        = string
  default     = "~/.ssh/demo2_home.pub"
}

variable "http_server_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = 80
}

variable "ssh_server_port" {
  description = "The port to ssh server"
  type        = number
  default     = 22
}

variable "logname_bastion" {
  description = "Name of log group"
  type        = string
}

variable "retention_bastion" {
  description = "How much time keep log in days"
  type        = number
  default     = null
}

variable "kms_key_bastion" {
  description = "The ARN of the KMS Key to use when encrypting logs"
  type        = string
  default     = null
}

variable "private_subnet_id" {
  description = "The id of the private subnet to launch the instances"
}

variable "public_subnet_id" {
  description = "The id of the public subnet to launch the load balancer"
}

variable "vpc_sg_id" {
  description = "The default security group from the vpc"
}