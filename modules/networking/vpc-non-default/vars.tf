variable "vpc_cidr" {
  description = "Base CIDR for the vpc.  Assumes a /16 so that it can calculate /24 subnets."
  type        = string
}

variable "environment" {
  description = "Environment type used to set the tags.  Typical names are stage, prod, dev, test"
  type        = string
}

variable "availability_zone_a" {
  description = "First availability zone to use for redundancy"
  type        = string
}

variable "availability_zone_b" {
  description = "Second availability zone to use for redundancy"
  type        = string
}
