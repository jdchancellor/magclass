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
    key            = "live/stage/app/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

data "aws_security_group" "rds_security_group" {
  tags = {
    Name        = "rds_security_group"
    environment = var.environment
  }
}


module "hello_world_app" {
  source = "../../../modules/services/hello-world-app"

  server_text = var.server_text

  environment                   = var.environment
  db_remote_state_bucket        = var.db_remote_state_bucket
  db_remote_state_bucket_region = var.db_remote_state_bucket_region
  db_remote_state_key           = var.db_remote_state_key

  instance_type         = "t2.micro"
  min_size              = 2
  max_size              = 2
  enable_autoscaling    = false
  rds_security_group_id = data.aws_security_group.rds_security_group.id
}

