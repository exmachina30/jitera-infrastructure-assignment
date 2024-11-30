terraform {
  backend "s3" {}
}

resource "aws_eip" "nat" {
  vpc = true  # Elastic IP for use in the VPC
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id  # Attach to the public subnet
  
  tags = {
    Name = "Main NAT Gateway"
  }
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "nat_eip" {
  value = aws_eip.nat.public_ip
}