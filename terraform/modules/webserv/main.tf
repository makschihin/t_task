########################################
# Security group for the web
########################################
resource "aws_security_group" "web_srv_sg" {
  name        = "${var.enviroment}-web-srv-sg"
  description = "Security group for web srv that allows web traffic from internet"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.enviroment}-web-srv-sg"
    Enviroment  = "${var.enviroment}"
  }
}

########################################
# Web Server Instance
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

resource "aws_instance" "websrv" {
  count                  = var.web_instance_count
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  iam_instance_profile   = "CWAgentRole"
  vpc_security_group_ids = [ aws_security_group.web_srv_sg.id ]
  key_name               = aws_key_pair.ec2key.key_name
  user_data              = "${file("${path.module}/files/user_data.sh")}"

  tags = {
    Name        = "${var.enviroment}-web-${count.index+1}"
    Enviroment  = "${var.enviroment}"
  }
}

########################################
# Cloud Watch Log Group
########################################
resource "aws_cloudwatch_log_group" "websrvlogs" {
  name              = var.logname_websrv
  retention_in_days = var.retention_websrv
  kms_key_id        = var.kms_key_websrv

  tags = {
    Name       = "${var.enviroment}-websrv"
    Enviroment = var.enviroment
  }
}

#############################
# Create ssh key
#############################
resource "aws_key_pair" "ec2key" {
  key_name   = "publicKeyA"
  public_key = file(var.public_key_path)
}