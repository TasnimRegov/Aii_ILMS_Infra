# PUBLIC RT
resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.tasnim-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name = "tasnim-pub-rt"
    }
}


# PRIVATE RT
resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.tasnim-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.natgw.id
    }
    tags = {
      Name = "tasnim-prv-rt"
    }
}


# RT ASSOCIATION
resource "aws_route_table_association" "rt-pub1" {
    subnet_id = aws_subnet.public-sub1.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "rt-pub2" {
    subnet_id = aws_subnet.public-sub2.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "rt-prv1" {
    subnet_id = aws_subnet.private-sub1.id
    route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "rt-prv2" {
    subnet_id = aws_subnet.private-sub2.id
    route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "rt-prot1" {
    subnet_id = aws_subnet.protected-sub1.id
    route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "rt-prot2" {
    subnet_id = aws_subnet.protected-sub2.id
    route_table_id = aws_route_table.private-rt.id
}

