output "vpc_id" {
  description = "The ID of the VPC created"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "The IDs of the private subnets created"
  value       = module.vpc.private_subnets[*]
}

output "vpc_security_group_id" {
  description = "Security group id for the VPC"
  value       = module.vpc.default_security_group_id
}

# output "db_subnet_group_name" {
#   description = "Name of database subnet group"
#   value       = module.vpc.database_subnet_group_name
# }

