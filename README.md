# 🌐 AWS 3-Tier Architecture with DMZ using Terraform

This project provisions a complete AWS infrastructure using **Terraform**, implementing a 3-tier architecture (DMZ, Application, and Database layers). Ideal for web applications that require scalability and security.

---

## 🧱 Architecture

```
                    Internet
                       │
              ┌──────▼──────┐
              │  ALB (Public)   │
              └─────┌──────┘
                      │
               ┌────▼────┐
               │ EC2 (App)  │  <- Private Subnet
               └────┌────┘
                      │
               ┌────▼────┐
               │ RDS (DB)   │  <- Private Subnet
               └───────────┘
```

---

## 📁 Folder Structure

```
.
├── compute.tf           # EC2 + ALB setup
├── database.tf          # RDS setup
├── networking.tf        # VPC, subnets, NAT, IGW, route tables
├── security_groups.tf   # Security Group rules
├── variables.tf         # Input variables
├── outputs.tf           # Infrastructure outputs
├── main.tf              # Terraform and AWS provider configuration
└── README.md
```

---

## ⚙️ Requirements

* Terraform ≥ `1.5.0`
* An active AWS account
* AWS CLI configured (`aws configure`)

---

## 🚀 Deployment Steps

### 1. Clone this repository

```bash
[git clone https://github.com/username/aws-dmz-terraform.git](https://github.com/fitrahasfar/Technical-Test-Nexmedis.git)
cd Technical-Test-Nexmedis
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Preview the infrastructure plan

```bash
terraform plan
```

### 4. Apply the infrastructure

```bash
terraform apply -auto-approve
```

---

## 🪩 Destroy All Resources

```bash
terraform destroy -auto-approve
```

---

## 🔐 Security Group Rules

| Component | Ingress                      | Egress    |
| --------- | ---------------------------- | --------- |
| ALB       | 80/443 from `0.0.0.0/0`      | Allow All |
| EC2       | 80 from ALB Security Group   | Allow All |
| RDS       | 3306 from EC2 Security Group | Allow All |

---

## 📤 Outputs

* `alb_dns_name` – Public DNS of the ALB
* `ec2_private_ip` – Private IP of EC2 App Server
* `rds_endpoint` – RDS MySQL connection endpoint

---

## 💡 Additional Notes

* EC2 instance runs a basic Apache web server using user\_data.
* Subnet CIDRs are configured to avoid overlap.
* The architecture can be further optimized for high availability (e.g., autoscaling, AZ redundancy).
