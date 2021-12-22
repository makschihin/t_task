########################################
# Create new vpc
########################################
resource "aws_vpc" "new_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
      Name       = "${var.enviroment}-vpc"
      Enviroment = var.enviroment
    }
}

########################################
# Internet gateway
########################################
resource "aws_internet_gateway" "ig" {
  vpc_id         = aws_vpc.new_vpc.id

  tags = {
      Name       = "${var.enviroment}-ig"
      Enviroment = var.enviroment
    }
}

########################################
# NAT
########################################
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

########################################
# Subnets
########################################
# Public
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.public_subnet
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  
  tags = {
      Name       = "${var.enviroment}-public-subnet"
      Enviroment = var.enviroment
    }
}

#Private
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.private_subnet
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  
  tags = {
      Name       = "${var.enviroment}-private-subnet"
      Enviroment = var.enviroment
    }  
}

########################################
# Routing tables
########################################
#Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.new_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.ig.id
  }
  
  tags = {
      Name       = "${var.enviroment}-publicRT"
      Enviroment = var.enviroment
    }
}

#Private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.new_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
      Name       = "${var.enviroment}-privateRT"
      Enviroment = var.enviroment
    }
}

# Route table associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

########################################
# Security group
########################################
resource "aws_security_group" "default" {
  name        = "${var.enviroment}-default-sg"
  description = "Default security group to allow in/out from the VPC"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

   egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags = {
    Enviroment = var.enviroment
  }
}

resource "aws_security_group" "ssh_bastion" {
  vpc_id        = aws_vpc.new_vpc.id
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
  subnet_id                   = aws_subnet.public_subnet.id
  user_data                   = "${file("${path.module}/files/user_data.sh")}"
  associate_public_ip_address = true

  tags = {
    Name       = "${var.enviroment}-bastion"
    Enviroment = var.enviroment
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