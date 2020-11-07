
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
    key            = "/live/stage/vpc/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

module "vpc" {
  source = "../../../modules/networking/vpc-non-default"

  vpc_cidr            = var.vpc_cidr
  environment         = var.environment
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
}
