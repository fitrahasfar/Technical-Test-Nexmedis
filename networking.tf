# VPC
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = { Name = "3tier-vpc" }
}

# Subnet Public 1 (AZ a)
resource "aws_subnet" "public_1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "${var.region}a"
    map_public_ip_on_launch = true
    tags = { Name = "public-dmz-1" }
}

# Subnet Public 2 (AZ b)
resource "aws_subnet" "public_2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "${var.region}b"
    map_public_ip_on_launch = true
    tags = { Name = "public-dmz-2" }
}

resource "aws_subnet" "private_app" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_app_subnet_cidr
    availability_zone = "${var.region}a"
    tags = { Name = "private-app" }
}

resource "aws_subnet" "private_db" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_db_subnet_cidr
    availability_zone = "${var.region}b"
    tags = { Name = "private-db" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = { Name = "main-igw" }
}

# NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = { Name = "nat-eip" }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_1.id
    tags = { Name = "main-nat" }
    depends_on = [aws_internet_gateway.igw]
}

# Route Tables
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = { Name = "public-rt" }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = { Name = "private-rt" }
}

# Route Table Associations
resource "aws_route_table_association" "public_1" {
    subnet_id      = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app" {
    subnet_id      = aws_subnet.private_app.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
    subnet_id      = aws_subnet.private_db.id
    route_table_id = aws_route_table.private.id
}