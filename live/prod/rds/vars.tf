# ------------------------------------------------------------------
# REQUIRED PARAMETERS
# A value must be provided for these parameters
# ------------------------------------------------------------------
variable "db_password" {
  description = "the password for the database"
  type        = string
}

# ------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults
# ------------------------------------------------------------------

variable "db_name" {
  description = "the name to use for the database"
  type        = string
  default     = "web_database_prod"
}

variable "db_username" {
  description = "the username for the database"
  type        = string
  default     = "admin"
}
