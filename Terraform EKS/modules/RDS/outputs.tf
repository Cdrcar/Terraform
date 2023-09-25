output "database_url" {
  description = "The DNS address of the DB instance"
  value       = aws_db_instance.mydb.address
}

output "port" {
  description = "The port that the database engine is listening on"
  value       = aws_db_instance.mydb.port
}

output "username" {
  description = "The master username for the database"
  value       = aws_db_instance.mydb.username
}

output "db_name" {
  description = "database name"
  value       = aws_db_instance.mydb.db_name
}

output "endpoint" {
  description = "used to establish connections to the RDS database from your applications or clients"
  value       = aws_db_instance.mydb.endpoint
}

output "password" {
  description = "database password"
  value       = aws_db_instance.mydb.password
}

