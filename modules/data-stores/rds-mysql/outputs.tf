output "db_address" {
  value       = aws_db_instance.webapp-rds.address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = aws_db_instance.webapp-rds.port
  description = "the port the database is listening on"
}

output "rds_security_group_id" {
  value       = aws_security_group.rds.id
  description = "the security group id created for the rds instances"
}
