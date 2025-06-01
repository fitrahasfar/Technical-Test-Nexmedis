output "alb_dns_name" {
    description = "DNS name of the ALB"
    value       = aws_lb.app.dns_name
}

output "ec2_private_ip" {
    description = "Private IP of EC2 instance"
    value       = aws_instance.app_server.private_ip
}

output "rds_endpoint" {
    description = "RDS connection endpoint"
    value       = aws_db_instance.main.endpoint
}