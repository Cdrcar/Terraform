output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_cluster.cluster_endpoint
}

# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane"
#   value       = module.eks_cluster.cluster_security_group_id
# }

# output "private_subnets_name" {
#   description = "Security group ids attached to the vpc"
#   value       = module.networking.vpc_security_group_id
# }

# output "vpc_security_group_id" {
#   description = "Security group ids attached to the vpc"
#   value       = module.vpc_security_group.security-group-id
# }

output "database_url" {
  description = "The DNS address of the DB instance"
  value       = "postgresql://${module.rds.username}:${module.rds.password}@${module.rds.endpoint}:${module.rds.port}/${module.rds.db_name}"
  sensitive   = true
}

# output "database_port" {
#   description = "The port that the database engine is listening on"
#   value       = module.rds.port
# }

# output "database_username" {
#   description = "The master username for the database"
#   value       = module.rds.username
# }

# output "database_name" {
#   description = "database name"
#   value       = module.rds.db_name
# }

