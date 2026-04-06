
key_name      = "483829975256-mumbai-key-pair"
aws_region    = "ap-south-1"
role_arn      = "arn:aws:iam::483829975256:role/s3-readonly-access-role"

# --- VPC Variables ---
name_prefix          = "my-dev-vpc"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]
