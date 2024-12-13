# LB - help route incoming traffic to proper target
# CREATE LOAD BALANCER - PUBLIC/WEB
resource "aws_lb" "public-lb" {
    name = "public-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [ aws_security_group.public-sg-lb.id ]
    subnets = [ aws_subnet.public-sub1.id, aws_subnet.public-sub2.id ]
    tags = {
      Environment = "Public-lb"
    }
}

# CREATE LOAD BALANCER - PRIVATE/APP
resource "aws_lb" "private-lb" {
    name = "private-lb"
    internal = true
    load_balancer_type = "application"
    security_groups = [ aws_security_group.private-sg-lb.id ]
    subnets = [ aws_subnet.private-sub1.id, aws_subnet.private-sub2.id ]
    tags = {
      Environment= "private-lb"
    }
}

###############################################################
# LOAD BALANCER TARGET GROUP - define server/instance that LoadBalancer can send traffic to.

# TG Public 
resource "aws_lb_target_group" "public-lb-tg" {
    name     = "pub-lb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.tasnim-vpc.id

    health_check {
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 10
        healthy_threshold   = 3
        unhealthy_threshold = 3
    }
}

# TG Private
resource "aws_lb_target_group" "private-lb-tg" {
    name     = "private-lb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.tasnim-vpc.id

    health_check {
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 10
        healthy_threshold   = 3
        unhealthy_threshold = 3
    }
}


###############################################################
# LB LISTENER - handle request from LB
# e.g : receptionist listen to customer then direct them to right department base on the req.
# the receptionist know which department to send 

# Public LB listener
resource "aws_lb_listener" "pub-lb-Listener" {
    load_balancer_arn = aws_lb.public-lb.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.public-lb-tg.arn
    }
}

# private LB listener
resource "aws_lb_listener" "prvt-lb-listener" {
    load_balancer_arn = aws_lb.private-lb.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.private-lb-tg.arn
    }
}



# Register the instances with the target group - web tier
resource "aws_autoscaling_attachment" "public-asattach" {
    autoscaling_group_name = aws_autoscaling_group.public-asg-instance.name
    lb_target_group_arn   = aws_lb_target_group.public-lb-tg.arn
}

# Register the instances with the target group - app tier
resource "aws_autoscaling_attachment" "private-asattach" {
    autoscaling_group_name = aws_autoscaling_group.private-asg-instance.name
    lb_target_group_arn   = aws_lb_target_group.private-lb-tg.arn   
}