# PUBLIC EC2
resource "aws_instance" "tasnim-public-server" {
    count = length(var.public-sub)
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.public_subnet[count.index].id 
    associate_public_ip_address = true
    security_groups = [ aws_security_group.public-sg.id ]

    tags = {
        Name = "TasPublic-server"
    }
}



# PRIVATE EC2
resource "aws_instance" "tasnim-private-server" {
    count = length(var.private-sub)
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.private_subnet[count.index].id
    vpc_security_group_ids = [aws_security_group.private-sg.id]

    tags = {
      Name = "TasPrivate-server"
    }
}



# PROTECTED EC2
# resource "aws_instance" "tasnim-protected-server" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     key_name = var.key_name
#     subnet_id = aws_subnet.protected_subnet.id
#     vpc_security_group_ids = [aws_security_group.private-sg.id]

#     tags = {
#       Name = "TasProtected-server"
#     }
# }

resource "aws_db_instance" "rds-db" {
    allocated_storage      = 10
    db_name                = var.db-name
    engine                 = "mysql"
    engine_version         = "5.7"
    instance_class         = var.instance_type
    username               = var.db-username
    password               = var.db-password
    parameter_group_name   = "default.mysql5.7"
    multi_az               = true
    db_subnet_group_name   = aws_db_subnet_group.rds-subnet-grp.name
    vpc_security_group_ids = [aws_security_group.protected-sg.id]
    skip_final_snapshot    = true
}