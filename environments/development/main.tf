
# --- VPC Module ---
module "vpc" {
  source               = "../../modules/vpc"
  name_prefix          = var.name_prefix
  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

# --- IAM Module ---
module "iam" {
  source       = "../modules/iam"
  cluster_name = var.cluster_name
}

# --- EKS Module ---
module "eks" {
  source               = "../modules/eks"
  cluster_name         = var.cluster_name
  eks_version          = var.eks_version
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  private_subnet_ids   = module.vpc.private_subnet_ids
  eks_node_role_arn    = module.iam.eks_cluster_node_role_arn

  # ensure cluster waits for VPC + IAM
  depends_on = [module.vpc, module.iam]
}
