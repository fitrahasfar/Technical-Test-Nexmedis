variable "region" {
    description = "AWS region"
    type        = string
    default     = "ap-southeast-1"
}

variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    description = "CIDR blocks for public subnets"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidr" {
    description = "CIDR for private app subnet"
    type        = string
    default     = "10.0.3.0/24"
}

variable "private_db_subnet_cidr" {
    description = "CIDR for private DB subnet"
    type        = string
    default     = "10.0.4.0/24"
}

variable "db_password" {
    description = "RDS root password"
    type        = string
    sensitive   = true
}