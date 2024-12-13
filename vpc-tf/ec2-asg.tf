# EC2 AUTO SCALING GROUP- PUBLIC
resource "aws_autoscaling_group" "public-asg-instance" {
    name = "public-asg-instance"
    launch_configuration = aws_launch_configuration.public-launch-config.id
    vpc_zone_identifier = [ aws_subnet.public-sub1.id, aws_subnet.public-sub2.id ]
    min_size = 2
    max_size = 3
    desired_capacity = 2
}


# EC2 AUTOSCALING GROUP - PRIVATE
resource "aws_autoscaling_group" "private-asg-instance" {
    name = "private-asg-instance"
    launch_configuration = aws_launch_configuration.private-launch-config.id
    vpc_zone_identifier = [ aws_subnet.private-sub1.id, aws_subnet.private-sub2.id ]
    min_size = 2
    max_size = 2
    desired_capacity = 2
}



######################################################################################
# LAUNCH CONFIGURATION FOR EC2 INSTANCE
resource "aws_launch_configuration" "public-launch-config" {
    name_prefix = "public-launch-config"
    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [ aws_security_group.pub-instance.id ]
    associate_public_ip_address = true
    
    lifecycle {
      prevent_destroy = true
      ignore_changes = all
    }

    user_data = <<-EOF
                #!/bin/bash

                # Update the system
                sudo yum -y update

                # Install Apache web server
                sudo yum -y install httpd

                # Start Apache web server
                sudo systemctl start httpd.service

                # Enable Apache to start at boot
                sudo systemctl enable httpd.service

                # Create index.html file with your custom HTML
                sudo echo '
                <!DOCTYPE html>
                <html lang="en">
                    <head>
                        <meta charset="utf-8" />
                        <meta name="viewport" content="width=device-width, initial-scale=1" />

                        <title>A Basic HTML5 Template</title>

                        <link rel="preconnect" href="https://fonts.googleapis.com" />
                        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                        <link
                            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap"
                            rel="stylesheet"
                        />

                        <link rel="stylesheet" href="css/styles.css?v=1.0" />
                    </head>

                    <body>
                        <div class="wrapper">
                            <div class="container">
                                <h1>Welcome TASNIM! An Apache web server has been started successfully.</h1>
                                <p>Replace this with your own index.html file in /var/www/html.</p>
                            </div>
                        </div>
                    </body>
                </html>

                <style>
                    body {
                        background-color: #34333d;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-family: Inter;
                        padding-top: 128px;
                    }

                    .container {
                        box-sizing: border-box;
                        width: 741px;
                        height: 449px;
                        display: flex;
                        flex-direction: column;
                        justify-content: center;
                        align-items: flex-start;
                        padding: 48px 48px 48px 48px;
                        box-shadow: 0px 1px 32px 11px rgba(38, 37, 44, 0.49);
                        background-color: #5d5b6b;
                        overflow: hidden;
                        align-content: flex-start;
                        flex-wrap: nowrap;
                        gap: 24;
                        border-radius: 24px;
                    }

                    .container h1 {
                        flex-shrink: 0;
                        width: 100%;
                        height: auto; /* 144px */
                        position: relative;
                        color: #ffffff;
                        line-height: 1.2;
                        font-size: 40px;
                    }
                    .container p {
                        position: relative;
                        color: #ffffff;
                        line-height: 1.2;
                        font-size: 18px;
                    }
                </style>
                ' > /var/www/html/index.html

                EOF
}



# LAUNCH CONFIG FOR EC2 INSTANCE
resource "aws_launch_configuration" "private-launch-config" {
    name_prefix = "private-launch-config"
    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [ aws_security_group.prv-instance.id ]
    associate_public_ip_address = false
    lifecycle {
      prevent_destroy = true
      ignore_changes = all
    }

    user_data = <<-EOF
                #!/bin/bash

                sudo yum install mysql -y

                EOF
}