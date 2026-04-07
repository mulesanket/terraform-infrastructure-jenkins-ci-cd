
terraform {
  backend "s3" {
    bucket         = "terraform-infrastructure-tfstate-backend-bucket"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-infra-state-lock-table-dev"
    encrypt        = true
  }
}