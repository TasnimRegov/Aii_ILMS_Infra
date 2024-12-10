# PUBLIC SECURITY GROUP--> EC2
resource "aws_security_group" "public-sg" {
    name = "tasnim-sg-public"
    vpc_id = aws_vpc.tasnim_vpc.id
    ingress {   # FOR SSH
        description = "TLS from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]   # Open to the world
    }
    ingress {   # FOR HTTP
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = {
      Name = "tasnim-public-sg"
    }
}


# PRIVATE SECURITY GROUP
resource "aws_security_group" "private-sg" {
    name        = "tasnim-sg-rds"
    vpc_id = aws_vpc.tasnim_vpc.id
    ingress {   # FOR SSH
        description = "TLS from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]   # Open to the world
    }
    ingress {   # FOR HTTP // port443->HTTPS
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = {
        Name = "tasnim-private-sg"
    }
}


# PROTECTED SECURITY GROUP
resource "aws_security_group" "protected-sg" {
    name        = "tasnim-sg-rds"
    vpc_id = aws_vpc.tasnim_vpc.id
    ingress {
        from_port   = 3306  # MySQL port
        to_port     = 3306
        protocol    = "tcp"
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "tasnim-protected-sg"
    }
}
