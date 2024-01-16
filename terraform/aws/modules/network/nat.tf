resource "aws_eip" "nat" {
  count = var.enable_nat ? 1 : 0
  domain = "vpc"
  tags = {
    "Name" = "${local.prefix}-nat"
  }
}
resource "aws_nat_gateway" "nat" {
  count = var.enable_nat ? 1 : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public_subnets[0].id

  tags = {
      Name = "${local.prefix}-nat"
    }

  depends_on = [aws_internet_gateway.igw]
  
}
