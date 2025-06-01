# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
    name       = "main-db-subnet-group"
    subnet_ids = [aws_subnet.private_db.id, aws_subnet.private_app.id]
    tags       = { Name = "db-subnet-group" }
}

# MySQL RDS Instance
resource "aws_db_instance" "main" {
    identifier             = "main-mysql-db"
    engine                = "mysql"
    engine_version        = "5.7"
    instance_class        = "db.t3.micro"
    allocated_storage     = 20
    username              = "admin"
    password              = var.db_password
    db_subnet_group_name  = aws_db_subnet_group.main.name
    vpc_security_group_ids = [aws_security_group.rds.id]
    skip_final_snapshot   = true
    tags                  = { Name = "main-db" }
}