
#VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

#ElasticIP-1
resource "aws_eip" "nat_eip_az1" {
}

#ElasticIP-2
resource "aws_eip" "nat_eip_az2" {
}

#NAT Gateway- AZ1
resource "aws_nat_gateway" "nat-1a" {
  allocation_id = aws_eip.nat_eip_az1.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.name_prefix}-nat-gw-1a"
  }
}

#NAT Gateway- AZ2
resource "aws_nat_gateway" "nat-1b" {
  allocation_id = aws_eip.nat_eip_az2.id
  subnet_id     = aws_subnet.public[1].id

  tags = {
    Name = "${var.name_prefix}-nat-gw-1b"
  }
}

#Public Subnet
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.name_prefix}-public-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

#Private Subnet
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name                                        = "${var.name_prefix}-private-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

#Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

#Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#Route Table for Private Subnet AZ1
resource "aws_route_table" "private-1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1a.id
  }

  tags = {
    Name = "${var.name_prefix}-private-rt-1a"
  }
}

#Route Table for Private Subnet AZ2
resource "aws_route_table" "private-1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1b.id
  }

  tags = {
    Name = "${var.name_prefix}-private-rt-1b"
  }
}

#Route Table Association for Private Subnet AZ1
resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private-1a.id
}

#Route Table Association for Private Subnet AZ2
resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private-1b.id
}