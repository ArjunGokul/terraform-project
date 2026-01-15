locals {
  common_tags = {
    Project = "Terraform-VPC"
    Owner   = "Nagarjuna SG"

  }
}

resource "aws_vpc" "create-vpc" {
  cidr_block = var.cidr_block
  region     = var.region
  tags = merge(local.common_tags, {
    Name = "non-default-vpc"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.create-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.create-vpc.cidr_block, 5, count.index)
  count                   = var.cnt
  availability_zone       = var.availability_zones[var.region][count.index]
  map_public_ip_on_launch = false
  depends_on = [
    aws_vpc.create-vpc
  ]
  tags = merge(local.common_tags, {
    Name = "public-subnet-${count.index + 1}"
  })
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.create-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.create-vpc.cidr_block, 5, count.index + var.cnt)
  count                   = var.cnt
  availability_zone       = var.availability_zones[var.region][count.index]
  map_public_ip_on_launch = false
  depends_on = [
    aws_vpc.create-vpc
  ]
  tags = merge(local.common_tags, {
    Name = "private-subnet-${count.index + 1}"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.create-vpc.id
  depends_on = [
    aws_vpc.create-vpc
  ]
  tags = merge(local.common_tags, {
    Name = "Internet-Gateway"
  })
}


resource "aws_eip" "nat-publicip" {
  domain = "vpc"
  tags = merge(local.common_tags, {
    Name = "NAT-Gateway-Public-IP"
  })
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-publicip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on = [
    aws_vpc.create-vpc
  ]
  tags = merge(local.common_tags, {
    Name = "NAT-Gateway"
  })
}


resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.create-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "public-route-table"
  })
}

resource "aws_route_table_association" "public_route" {
  count          = var.cnt
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-route.id
}


resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.create-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = merge(local.common_tags, {
    Name = "private-route-table"
  })
}

resource "aws_route_table_association" "private_route" {
  count          = var.cnt
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private-route.id
}

output "vpc_id" {
  value = aws_vpc.create-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

