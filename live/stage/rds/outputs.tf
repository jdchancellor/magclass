output "address" {
  value       = module.rds.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.rds.port
  description = "the port the database is listening on"
}
