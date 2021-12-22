variable "enviroment" {
  default = "stage"
}

variable "public_key_path" {
  description = "Public key path for SSH to the instance"
  type        = string
  default     = "~/.ssh/demo2_home.pub"
}

variable "region" {
  description = "Region that the instances will be created"
}

variable "availability_zone" {
  description = "The AZ that the resources will be launched"
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

# Network
variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
}

variable "public_subnet" {
  description = "The CIDR block of the public subnet"
}

variable "private_subnet" {
  description = "The CIDR block of the private subnet"
}

# Web
variable "web_instance_count" {
  description = "The total of web instances to run"
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