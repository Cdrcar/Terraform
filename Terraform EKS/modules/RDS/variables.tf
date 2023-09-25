# variable "vpc_id" {
#   description = "The ID of the VPC to place the cluster id"
#   type        = string
# }

variable "vpc_security_group_id" {
  description = "Security group id for the VPC"
  type        = list(string)
}

# variable "rds_db_subnet_group_name" {
#   description = "Name of the RDS DB subnet group"
#   type        = string
# }

variable "private_subnets" {
  description = "Private Subnet IDs for the cluster"
  type        = list(string)
}