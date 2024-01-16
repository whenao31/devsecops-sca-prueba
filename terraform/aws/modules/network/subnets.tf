data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private_subnets" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index+1]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  vpc_id            = aws_vpc.main.id

  tags = {
    "Name" = "private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }

}

resource "aws_subnet" "public_subnets" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index+1]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index*2 + 5)
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}