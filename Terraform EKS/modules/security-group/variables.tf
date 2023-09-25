# variable "main_vpc_cidr" {
#   type        = string
#   description = "the main vpc"

# }

# variable "managedby" {
#   description = "How create and manage this resources"
#   type        = string
# }

# variable "ssh_cidr_block" {
#   type = string

#   description = "CIDR block for SSH access"
# }

# variable "name-security-group" {
#   description = "the name of the security group"
#   type        = string

# }

variable "vpc_id" {
  description = "the ID of the VPC"
  type        = string
}
