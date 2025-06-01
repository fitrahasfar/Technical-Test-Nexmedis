# Application Load Balancer
resource "aws_lb" "app" {
    name               = "app-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id] # Gunakan 2 subnet

    enable_deletion_protection = true

    tags = {
        Name = "app-alb"
    }
}

# ALB Target Group
resource "aws_lb_target_group" "app" {
    name     = "app-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.main.id

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = {
        Name = "app-target-group"
    }
}

# ALB Listener
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.app.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app.arn
    }
}

# EC2 Instance dengan user_data inline (menggantikan file external)
resource "aws_instance" "app_server" {
    ami                    = "ami-01938df366ac2d954"
    instance_type          = "t3.micro"
    subnet_id              = aws_subnet.private_app.id
    vpc_security_group_ids = [aws_security_group.ec2.id]
    
    # User data untuk install dan konfigurasi web server
    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
                EOF

    tags = {
        Name = "AppServer"
    }

    lifecycle {
        prevent_destroy = false # Mencegah penghapusan tidak sengaja
    }
    }

    # Attachment Target Group ke EC2 Instance
    resource "aws_lb_target_group_attachment" "app" {
    target_group_arn = aws_lb_target_group.app.arn
    target_id        = aws_instance.app_server.id
    port             = 80
}