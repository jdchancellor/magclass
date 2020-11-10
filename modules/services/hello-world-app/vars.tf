# ------------------------------------------------------------------
# REQUIRED PARAMETERS
# A value must be provided for these parameters
# ------------------------------------------------------------------

variable "environment" {
  description = "the name of the environment the app is deploying to"
  type        = string
}

variable "min_size" {
  description = "the minimum number of EC2 instances in the Autoscaling group"
  type        = number
}

variable "max_size" {
  description = "the maximum number of EC2 instances in the Autoscaling group"
  type        = number
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto-scaling schedule"
  type        = bool
}

variable "db_remote_state_bucket" {
  description = "the name of the s3 bucket used for the databases remote state storage"
  type        = string
}

variable "db_remote_state_key" {
  description = "the name of the key in the s3 bucket used for the databases remote state storage"
  type        = string
}

variable "db_remote_state_bucket_region" {
  description = "the region of the s3 bucket used for the databases remote state storage"
  type        = string
}

variable "rds_security_group_id" {
  description = "The security group id for the rds instances"
  type        = string
}

# ------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults
# ------------------------------------------------------------------

variable "instance_type" {
  description = "the type of ec2 instances to run"
  type        = string
  default     = "t2.micro"
}

variable "server_text" {
  description = "the text the web server should return"
  default     = "hello, world"
  type        = string
}

variable "server_port" {
  description = "the port the server will use for http requests"
  type        = number
  default     = 8080
}

variable "custom_tags" {
  description = "custom tags to set on the instances in the autoscaling group"
  type        = map(string)
  default     = {}
}
