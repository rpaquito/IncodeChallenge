# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.deploy_name}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.deploy_name}-igw"
  }
}
########################
# PUBLIC
########################
# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.deploy_name}-public-route-table"
  }
}

# Public Subnet A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.deploy_name}-public-subnet-a"
  }
}

# Public Route Table Association A
resource "aws_route_table_association" "public_route_table_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

# Public Subnet B
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.deploy_name}-public-subnet-b"
  }
}

# Public Route Table Association B
resource "aws_route_table_association" "public_route_table_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

########################
# PRIVATE
########################
# Private Subnet A
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.deploy_name}-private-subnet-a"
  }
}

# Private Route Table Association A 
resource "aws_route_table_association" "private_route_table_association_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

# Private Subnet B
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.deploy_name}-private-subnet-b"
  }
}

# Private Route Table Association B
resource "aws_route_table_association" "private_route_table_association_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}


# Private Route Table A
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = {
    Name = "${var.deploy_name}-private-route-table-a"
  }
}

# Private Route Table B
resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }

  tags = {
    Name = "${var.deploy_name}-private-route-table-b"
  }
}

# NAT Gateway A
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.private_nat_eip_a.allocation_id
  subnet_id     = aws_subnet.public_subnet_a.id
  depends_on    = [aws_internet_gateway.igw]
}

# NAT Gateway B
resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.private_nat_eip_b.allocation_id
  subnet_id     = aws_subnet.public_subnet_b.id
  depends_on    = [aws_internet_gateway.igw]
}

# Elastic IP
resource "aws_eip" "private_nat_eip_a" {
  vpc = true
}

resource "aws_eip" "private_nat_eip_b" {
  vpc = true
}

########################
# DATABASE
########################
# Database Subnet A
resource "aws_subnet" "db_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.deploy_name}-db-subnet-a"
  }
}
 
# Database Subnet B
resource "aws_subnet" "db_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.deploy_name}-db-subnet-b"
  }
}

