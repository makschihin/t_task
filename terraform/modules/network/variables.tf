variable "vpc_cidr" {
  description = "The CIDR block of new VPC"
}

variable "public_subnet" {
  description = "The CIDR block of public subnet"
}

variable "private_subnet" {
  description = "The CIDR block of private subnet"
}

variable "enviroment" {
  description = "The enviroment"
}

variable "region" {
  description = "The region to launch hosts"
}

variable "availability_zone" {
  description = "The AZ that the resources will be launched"
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
