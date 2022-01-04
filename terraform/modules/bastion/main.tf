########################################
# Security group for bastion
########################################
resource "aws_security_group" "ssh_bastion" {
  vpc_id        = "${var.vpc_id}"
  description   = "Allow SSH to bastion"
  name          = "${var.enviroment}-bastion-host"

  ingress {
    from_port   = var.ssh_server_port
    to_port     = var.ssh_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.enviroment}-bastion-sg"
    Enviroment = var.enviroment
  }
}

########################################
# Bastion host
########################################
# Get latest AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners   = ["amazon"]
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ec2key.key_name
  vpc_security_group_ids      = [ aws_security_group.ssh_bastion.id ]
  iam_instance_profile        = "CWAgentRole" 
  subnet_id                   = var.public_subnet_id
  user_data                   = data.template_file.init.rendered #"${file("${path.module}/files/user_data.sh")}"
  associate_public_ip_address = true

  tags = {
    Name       = "${var.enviroment}-bastion"
    Enviroment = var.enviroment
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/files/init.tpl")}"
  vars = {
    "consul_address" = "${aws_cloudwatch_log_group.bastionlogs.name}"
  }
}

########################################
# Cloud Watch Log Group
########################################
resource "aws_cloudwatch_log_group" "bastionlogs" {
  name              = var.logname_bastion
  retention_in_days = var.retention_bastion
  kms_key_id        = var.kms_key_bastion

  tags = {
    Name       = "${var.enviroment}-bastion"
    Enviroment = var.enviroment
  }
}

#############################
# Create ssh key
#############################
resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = file(var.public_key_path)
}