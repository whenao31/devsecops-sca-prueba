#Get main route table to modify
data "aws_route_table" "main_route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
}

# Create route table in us-east-1
resource "aws_default_route_table" "public" {
  default_route_table_id = data.aws_route_table.main_route_table.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.prefix}-public-rt"
  }
}

resource "aws_route_table" "private" {
  count = var.enable_nat ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
 tags = {
   Name = "${local.prefix}-private-rt"
 }
}

resource "aws_route_table_association" "private" {
  count = var.enable_nat ? length(aws_subnet.private_subnets[*].id) : 0
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public_subnets[*].id)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_default_route_table.public.id
}
