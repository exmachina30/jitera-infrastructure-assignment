terraform {
  backend "s3" {}
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main VPC"
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}

# Create the Internet Gateway (IGW)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main IGW"
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}

# Create a Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}

# Create a Private Subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Private Subnet"
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}

# Create 2nd Private Subnet
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "Private Subnet 2"
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}

resource "aws_security_group" "msk_security_group" {
  name_prefix = "msk-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 9092
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Update with your VPC CIDR or specific IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value       = [
    aws_subnet.private.id,
    aws_subnet.private_2.id
  ]
}

output "all_subnet_ids" {
  description = "The IDs of all subnets"
  value       = [
    aws_subnet.public.id,
    aws_subnet.private.id,
    aws_subnet.private_2.id
  ]
}

output "msk_security_group_id" {
  value = aws_security_group.msk_security_group.id
}
