# ------------------------------------------------------------------
# REQUIRED PARAMETERS
# A value must be provided for these parameters
# ------------------------------------------------------------------

variable "alb_name" {
  description = "The name to use for the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet ids for the ALB to deploy into"
  type        = list(string)
}
