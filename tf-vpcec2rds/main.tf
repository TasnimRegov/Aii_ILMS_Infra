# DECLATE PROVIDER
provider "aws" {
    region = var.region
}

# CREATE VPC
resource "aws_vpc" "tasnim_vpc" {
    cidr_block = var.cidr_block
    tags = {
        Name = "Tasnim VPC"
    } 
}

# CREATE INTERNET GATEWAT --> attach to vpc
resource "aws_internet_gateway" "tasnim-igw" {
    vpc_id = aws_vpc.tasnim_vpc.id
    tags = {
        Name = "Internet Gateway"
    }
}



# CREATE PUBLIC SUBNET
resource "aws_subnet" "public_subnet" {
    vpc_id     = aws_vpc.tasnim_vpc.id
    count = length(var.public-sub)
    availability_zone = var.azs[count.index]
    cidr_block = var.public-sub[count.index]
    tags = {
        Name = "TasPublic-Subnet ${count.index + 1}"
    }
}

# CREATE PRIVATE SUBNET-1(NATGATEWAY)
resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.tasnim_vpc.id
    count = length(var.private-sub)
    availability_zone = var.azs[count.index]
    cidr_block = var.private-sub[count.index]
    tags = {
        Name = "TasPrivate-Subnet ${count.index + 1}"
    }
}


# CREATE PROTECTED SUBNET ( private2 // RDS )
resource "aws_subnet" "protected_subnet" {
    vpc_id     = aws_vpc.tasnim_vpc.id
    count = length(var.protected-sub)
    availability_zone = var.azs[count.index]
    cidr_block = var.protected-sub[count.index]
    tags = {
        Name = "TasProtected-Subnet ${count.index + 1}"
    }
}



# DECLATRE AWS ElasticIP (EIP) for NAT
resource "aws_eip" "nat_gw_eip" {
    domain = "vpc"
}

# CREATE NATGATEWAY in PUBLIC SUBNET
resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat_gw_eip.id
    subnet_id = aws_subnet.public_subnet[0].id
    tags = {
        Name = "NATGT"
    }
}



# DB SUBNET GROUP FOR RDS
resource "aws_db_subnet_group" "rds-subnet-grp" {
    name = var.db-subnet-group
    # subnet_ids = tolist(aws_subnet.protected_subnet[*].id)
    subnet_ids = [aws_subnet.protected_subnet[count.index].id]
}