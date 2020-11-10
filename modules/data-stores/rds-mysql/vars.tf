# ------------------------------------------------------------------
# REQUIRED PARAMETERS
# A value must be provided for these parameters
# ------------------------------------------------------------------

variable "db_name" {
  description = "The name to use for the database"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the db_username user to access the database"
  type        = string
}

variable "environment" {
  description = "The environment name for the deployment"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id for the vpc used in the deployment"
}

