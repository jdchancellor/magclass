# ------------------------------------------------------------------
# REQUIRED PARAMETERS
# A value must be provided for these parameters
# ------------------------------------------------------------------

variable "cluster_name" {
  description = "the name to use as the root for cluster resources"
  type        = string
}

variable "ami" {
  description = "The AMI id to use in the launch configuration instances of the cluster"
  type        = string
}

variable "instance_type" {
  description = "the type of EC2 instances to run (e.g. t2.micro)"
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

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto-scaling schedule"
  type        = bool
}

# ------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults
# ------------------------------------------------------------------

variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform.  Must be one of: EC2, ELB"
  type        = string
  default     = "EC2"
}

variable "user_data" {
  description = "The user_data script to run in each instance at boot"
  type        = string
  default     = null
}

variable "custom_tags" {
  description = "Custom tags to set on each instance of the ASG"
  type        = map(string)
  default     = {}
}

variable "server_port" {
  description = "the port number that the cluster will use to listen for HTTP requests"
  type        = number
  default     = 8080
}
