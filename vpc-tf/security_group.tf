# PUBLIC LOAD BALANCER - SECURITY GROUP
resource "aws_security_group" "public-sg-lb" {
    name = "public-sg-lb"
    vpc_id = aws_vpc.tasnim-vpc.id
    depends_on = [ aws_vpc.tasnim-vpc ]

    ingress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "public-sg-lb"
    }
}

# PRIVATE LOAD BALANCER - SECURITY GROUP
resource "aws_security_group" "private-sg-lb" {
    name        = "private-sg-lb"
    description = "load balancer security group for app tier"
    vpc_id      = aws_vpc.tasnim-vpc.id
    depends_on = [ aws_vpc.tasnim-vpc ]

    ingress {
        from_port          = "80"
        to_port            = "80"
        protocol           = "tcp"
        security_groups    = [aws_security_group.public-sg-lb.id]
    }
    tags = {
        Name = "private-sg-lb"
    }
}

##########################################################################

# PUBLIC SECURITY GROUP - AUTO SCALLING GROUP
resource "aws_security_group" "pub-instance" {
    name = "pub-instance"
    description = "allow traffic from VPC"
    vpc_id = aws_vpc.tasnim-vpc.id
    depends_on = [ aws_vpc.tasnim-vpc ]

    ingress {
        from_port = "0"
        to_port   = "0"
        protocol  = "-1"
    }
    ingress {   # HTTP
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {   # SSH
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "pub-instance"
    }
}

# PRIVATE SECURITY GROUP - AUTO SCALLING GROUP
resource "aws_security_group" "prv-instance" {
    name = "prv-instance"
    description = "alloww traffic from public"
    vpc_id = aws_vpc.tasnim-vpc.id
    depends_on = [ aws_vpc.tasnim-vpc ]

    ingress {
        from_port = "-1"
        to_port   = "-1"
        protocol  = "icmp"
        security_groups  = [aws_security_group.pub-instance.id]
    }
    ingress {   # HTTP
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        security_groups  = [aws_security_group.pub-instance.id]
    }
    ingress {   # SSH
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        security_groups  = [aws_security_group.pub-instance.id]
    }
    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "prv-instance"
    }
}

#########################################################################

# DB/PROTECTED SECURITY GROUP
resource "aws_security_group" "db-instance" {
    name = "db-instance"
    description = "allow traffic from private"
    vpc_id = aws_vpc.tasnim-vpc.id

    ingress {   
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks      = ["10.0.0.32/28" , "10.0.0.48/28"]
        description      = "Access for the public ALB SG"
        #security_groups = [aws_security_group.prlw-webalb-sg.id]
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.prv-instance.id]
        cidr_blocks     = ["10.0.0.0/16"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}