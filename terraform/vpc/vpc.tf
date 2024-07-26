
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.name}-vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet)
  availability_zone = element(var.availability_zone, count.index)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet, count.index)

  tags = {
    Name = "${var.name}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.private_subnet, count.index)

  tags = {
    Name = "${var.name}-private-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-gw"
  }
}

resource "aws_nat_gateway" "nat" {
  #count = length(var.public_subnet)
  allocation_id = aws_eip.vpc.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.name}-nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


resource "aws_eip" "vpc" {
  domain = "vpc"
}