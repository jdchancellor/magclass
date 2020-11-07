# ------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults
# ------------------------------------------------------------------

variable "vpc_cidr" {
  description = "Base CIDR for the vpc.  Assumes a /16 so that it can calculate /24 subnets."
  type        = string
  default     = "10.1.0.0/16"
}

variable "environment" {
  description = "Environment type used to set the tags.  Typical names are stage, prod, dev, test"
  type        = string
  default     = "prod"
}

variable "availability_zone_a" {
  description = "First availability zone to use for redundancy"
  type        = string
  default     = "us-west-2a"
}

variable "availability_zone_b" {
  description = "Second availability zone to use for redundancy"
  type        = string
  default     = "us-west-2b"
}
