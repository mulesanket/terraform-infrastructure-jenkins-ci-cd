
terraform {
  backend "s3" {
    bucket         = "terraform-infrastructure-tfstate-backend-prod-bucket"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-infra-state-lock-table-prod"
    encrypt        = true
  }
}