
variable "web_instance_count" {
  description = "The total of web instances to run"
}

variable "region" {
  description = "The region to launch the instances"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
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

variable "vpc_cidr" {
  description = "The CIDR block from the VPC"
}

variable "public_key_path" {
  description = "Public key path for SSH to the instance"
  type        = string
  default     = "~/.ssh/demo2_home.pub"
}
variable "enviroment" {
  description = "The environment for the instance"
}

variable "key_name" {
  default     = "public"
  description = "The name of the ssh key"
}

variable "vpc_id" {
  description = "The id of the vpc"
}

variable "logname_websrv" {
  description = "Name of log group"
  type        = string
}

variable "retention_websrv" {
  description = "How much time keep log in days"
  type        = number
  default     = null
}

variable "kms_key_websrv" {
  description = "The ARN of the KMS Key to use when encrypting logs"
  type        = string
  default     = null
}