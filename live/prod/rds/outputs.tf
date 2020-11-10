output "address" {
  value       = module.rds.db_address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.rds.db_port
  description = "the port the database is listening on"
}

output "rds_security_group_id" {
  value       = module.rds.rds_security_group_id
  description = "the security group id created for the rds instances"
}
