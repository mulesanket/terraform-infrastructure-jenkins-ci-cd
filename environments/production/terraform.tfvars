
key_name   = "315435444725-ap-south-1-keypair"
aws_region = "ap-south-1"
role_arn   = "arn:aws:iam::315435444725:role/TerraformExecutionRole-Prod"

# --- VPC Variables ---
name_prefix          = "my-prod"
cluster_name         = "my-prod-eks-cluster"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
azs                  = ["ap-south-1a", "ap-south-1b"]