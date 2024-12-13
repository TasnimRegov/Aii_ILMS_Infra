# PROVIDER
provider "aws" {
    region = var.region
}

# VPC
resource "aws_vpc" "tasnim-vpc" {
    cidr_block = var.cidr_block
    tags = {
      Name = "Tasnim VPC"
    }
}


# PUBLIC SUBNET
resource "aws_subnet" "public-sub1" {
    vpc_id = aws_vpc.tasnim-vpc.id
    cidr_block = "10.0.0.0/28"
    availability_zone = var.availability_zone-a
    map_public_ip_on_launch = "true"
    tags = {
      Name = "tasnim-public1"
    }
}
resource "aws_subnet" "public-sub2" {
    vpc_id = aws_vpc.tasnim-vpc.id
    cidr_block = "10.0.0.16/28"
    availability_zone = var.availability_zone-b
    map_public_ip_on_launch = "true"
    tags = {
      Name = "tasnim-public2"
    }
}


# PRIVATE SUBNET
resource "aws_subnet" "private-sub1" {
    vpc_id = aws_vpc.tasnim-vpc.id
    cidr_block = "10.0.0.32/28"
    availability_zone = var.availability_zone-a
    map_public_ip_on_launch = "false"
    tags = {
      Name = "tasnim-private1"
    }
}
resource "aws_subnet" "private-sub2" {
    vpc_id = aws_vpc.tasnim-vpc.id
    cidr_block = "10.0.0.48/28"
    availability_zone = var.availability_zone-b
    map_public_ip_on_launch = "false"
    tags = {
      Name = "tasnim-private2"
    }
}


# PROTECTED/RDS SUBNET
resource "aws_subnet" "protected-sub1" {
    vpc_id = aws_vpc.tasnim-vpc.id
    cidr_block = "10.0.0.64/28"
    availability_zone = var.availability_zone-a
    map_public_ip_on_launch = "false"
    tags = {
      Name = "tasnim-protected1"
    }
}
resource "aws_subnet" "protected-sub2" {
    vpc_id = aws_vpc.tasnim-vpc.id
    cidr_block = "10.0.0.80/28"
    availability_zone = var.availability_zone-b
    map_public_ip_on_launch = "false"
    tags = {
      Name = "tasnim-protected2"
    }
}


# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.tasnim-vpc.id
    tags = {
      Name = "tasnim-IGW"
    }
}


# EIP FOR NAT
resource "aws_eip" "nat-eip" {
    domain = "vpc"
}


# NAT GATEWAY
resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat-eip.id
    subnet_id = aws_subnet.public-sub1.id
    depends_on = [ aws_internet_gateway.igw ]
    tags = {
      Name = "tasnim-NATGW"
    }
}