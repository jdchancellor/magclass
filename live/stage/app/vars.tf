# ------------------------------------------------------------------
# REQUIRED PARAMETERS
# A value must be provided for these parameters
# ------------------------------------------------------------------

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the databases remote state"
  type        = string
  default     = "jdchancellor-terraform-state"
}

variable "db_remote_state_key" {
  description = "The path for the databases remote state in s3"
  type        = string
  default     = "live/stage/rds/terraform.tfstate"
}

variable "db_remote_state_bucket_region" {
  description = "the database remote state bucket's region"
  type        = string
  default     = "us-west-2"
}

# ------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults
# ------------------------------------------------------------------

variable "server_text" {
  description = "the text the web server should return"
  default     = "Hello, World"
  type        = string
}

variable "environment" {
  description = "the name of the environment being deployed to "
  type        = string
  default     = "stage"
}
