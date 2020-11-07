terraform {
  required_version = ">= 0.13, <0.14"
}

provider "aws" {
  region = "us-west-2"

  #in the future fix the version of the AWS provider
  #version = "~> 2.0"
}

terraform {
  backend "s3" {
    bucket         = "jdchancellor-terraform-state"
    key            = "/live/stage/rds/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

module "rds" {
  source = "../../../modules/data-stores/rds-mysql"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
