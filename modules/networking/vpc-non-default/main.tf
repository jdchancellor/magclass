terraform {
  required_version = ">=0.13, <0.14"
}

resource "aws_vpc" "vpc-non-default" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name        = "vpc-${var.environment}"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc-non-default.id

  tags = {
    Name        = "vpc_igw-${var.environment}"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_subnet" "vpc_subnet_servers_a" {
  vpc_id                  = aws_vpc.vpc-non-default.id
  cidr_block              = cidrsubnet(var.vpc_cider, 8, 0)
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = false

  tags = {
    Name        = "vpc_subnet_servers_a"
    Type        = "instances"
    Environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_subnet" "vpc_subnet_servers_b" {
  vpc_id                  = aws_vpc.vpc-non-default.id
  cidr_block              = cidrsubnet(var.vpc_cider, 8, 1)
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = false

  tags = {
    Name        = "vpc_subnet_servers_b"
    Type        = "instances"
    Environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_subnet" "vpc_subnet_load_balancers_a" {
  vpc_id            = aws_vpc.vpc-non-default.id
  cidr_block        = cidrsubnet(var.vpc_cider, 8, 2)
  availability_zone = var.availability_zone_a

  tags = {
    Name        = "vpc_subnet_load_balancers_a"
    Type        = "loadbalancers"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_subnet" "vpc_subnet_load_balancers_b" {
  vpc_id            = aws_vpc.vpc-non-default.id
  cidr_block        = cidrsubnet(var.vpc_cider, 8, 3)
  availability_zone = var.availability_zone_b

  tags = {
    Name        = "vpc_subnet_load_balancers_b"
    Type        = "loadbalancers"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_subnet" "vpc_subnet_rds_a" {
  vpc_id            = aws_vpc.vpc-non-default.id
  cidr_block        = cidrsubnet(var.vpc_cider, 8, 4)
  availability_zone = var.availability_zone_a

  tags = {
    Name        = "vpc_subnet_rds_a"
    Type        = "rds"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_subnet" "vpc_subnet_rds_b" {
  vpc_id            = aws_vpc.vpc-non-default.id
  cidr_block        = cidrsubnet(var.vpc_cider, 8, 5)
  availability_zone = var.availability_zone_b

  tags = {
    Name        = "vpc_subnet_rds_b"
    Type        = "rds"
    environment = var.environment
    Createdby   = "terraform"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc-non-default.id

  tags = {
    Name        = "public"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc-non-default.id

  tags = {
    Name        = "private"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_route_table_association" "server_a_public" {
  subnet_id      = aws_subnet.vpc_subnet_servers_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "server_b_public" {
  subnet_id      = aws_subnet.vpc_subnet_servers_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "loadbalancer_a_public" {
  subnet_id      = aws_subnet.vpc_subnet_load_balancers_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "loadbalancer_b_public" {
  subnet_id      = aws_subnet.vpc_subnet_load_balancers_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rds_a_private" {
  subnet_id      = aws_subnet.vpc_subnet_rds_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "rds_b_private" {
  subnet_id      = aws_subnet.vpc_subnet_rds_b.id
  route_table_id = aws_route_table.private.id
}

###########build public Routes ##############
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_igw.id
  depends_on             = [aws_route_table.public]
}








