# Local variables def
locals {
  prefix = "devsecops-sca"
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${local.prefix}-igw"
  }
}