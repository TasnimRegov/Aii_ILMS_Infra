###  PUBLIC ###
resource "aws_route_table" "public_rt" {    # routing internet to public subnet
    vpc_id = aws_vpc.tasnim_vpc.id
    route {       
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tasnim-igw.id
    }
    tags = {
        Name = "PublicRT"
    }
}
resource "aws_route_table_association" "public-rt-association" {
    count = length(aws_subnet.public_subnet)
    subnet_id      = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}



###  PRIVATE1 ###
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.tasnim_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw.id
    }
    tags = {
        Name = "PrivateRT"  # main RT for NAT
    }
}
resource "aws_route_table_association" "private-rt-association" {
    count = length(aws_subnet.private_subnet)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rt.id
}




### NATGATEWAY ROUTE ###
resource "aws_route" "NATgw-route" {
    route_table_id = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id

    depends_on = [ aws_eip.nat_gw_eip ]
}




# ### PROTECTED ###
# resource "aws_route_table" "protected_rt" {
#     vpc_id = aws_vpc.tasnim_vpc.id
#     tags = {
#         Name = "ProtectedRT"
#     }
# }
# resource "aws_route_table_association" "protected-rt-association" {
#   subnet_id = aws_subnet.private_subnet[count.index].id
#   route_table_id = aws_route_table.protected_rt.id
# }



# resource "aws_route_table" "public_route_table" {
#     vpc_id = aws_vpc.tasnim_vpc.id
#     tags = {
#         Name = "my-public-rt"
#     }
# }
# resource "aws_route" "public_route" {
#     route_table_id         = aws_route_table.public_route_table.id
#     destination_cidr_block = "0.0.0.0/0"
#     gateway_id             = aws_internet_gateway.tasnim-igw.id
# }
# resource "aws_route_table_association" "public_subnet_association" {
#     count = length(aws_subnet.public_subnet)
#     subnet_id      = aws_subnet.public_subnet[count.index].id
#     route_table_id = aws_route_table.public_route_table.id
# }