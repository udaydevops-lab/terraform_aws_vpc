resource "aws_vpc" "roboshop" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.Name
    }
  ) // this is a merge function which merhe the both tags in variables
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
      Name = local.Name
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.roboshop.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = local.aznames[count.index]

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.Name}-public-${local.aznames[count.index]}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.roboshop.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.aznames[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.Name}-private-${local.aznames[count.index]}"
    }
  )
}

resource "aws_subnet" "database_subnet" {
  count             = length(var.database_subnet_cidr)
  vpc_id            = aws_vpc.roboshop.id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = local.aznames[count.index]

  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
      Name = "${local.Name}-database-${local.aznames[count.index]}"
    }
  )
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    var.common_tags,
    var.nat_gw_tags,
    {
      Name = local.Name
    }
  )
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,

    {
      Name = "${local.Name}-public"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(
    var.common_tags,
    var.private_route_table_tags,

    {
      Name = "${local.Name}-private"
    }
  )
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(
    var.common_tags,
    var.database_route_table_tags,

    {
      Name = "${local.Name}-database"
    }
  )
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = var.public_route
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = var.public_route
  gateway_id = aws_nat_gateway.gw.id
}

resource "aws_route" "database_route" {
  route_table_id = aws_route_table.database_route_table.id
  destination_cidr_block = var.public_route
  gateway_id = aws_nat_gateway.gw.id
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route.public_route.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route.private_route.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id = element(aws_subnet.database_subnet[*].id, count.index)
  route_table_id = aws_route.database_route.id
}