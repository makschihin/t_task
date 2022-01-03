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