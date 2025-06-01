# ALB Security Group (DMZ)
resource "aws_security_group" "alb" {
    name        = "alb-sg"
    description = "Allow HTTP/HTTPS to ALB"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "alb-sg" }
}

# EC2 Security Group (App Layer)
resource "aws_security_group" "ec2" {
    name        = "ec2-sg"
    description = "Allow traffic from ALB only"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "ec2-sg" }
}

# RDS Security Group (DB Layer)
resource "aws_security_group" "rds" {
    name        = "rds-sg"
    description = "Allow traffic from EC2 only"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.ec2.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "rds-sg" }
}