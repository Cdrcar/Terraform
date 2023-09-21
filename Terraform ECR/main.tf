provider "aws" {
  region = "us-east-1"
}


# resource "aws_ecr_repository" "frontend-repository" {
#   name                 = "frontend-repository"
# }

module "public_ecr_frontend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "frontend-group"
  repository_type = "public"
}

# output "frontend_ecr_repository_url" {
#   value = module.public_ecr_frontend.repository_url
# }

# resource "aws_ecr_repository" "backend-repository" {
#   name                 = "backend-repository"
# }

module "public_ecr_backend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "backend-group"
  repository_type = "public"
}

# output "backend_ecr_repository_url" {
#   value = module.public_ecr_backend.repository_url
# }

