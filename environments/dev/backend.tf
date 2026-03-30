
terraform {
  backend "s3" {
    bucket         = "terraform-infrastructure-tfstate-backend-bucket"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-infra-state-lock-table"
    encrypt        = true

    assume_role {
      role_arn = "arn:aws:iam::483829975256:role/TerraformExecutionRole"
    }
  }
}