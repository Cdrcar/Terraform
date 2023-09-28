# Provision the VPC network
module "networking" {
  source = "./modules/networking"

  vpc_name     = var.vpc_name
  cluster_name = var.cluster_name
}

# Provision cluster
module "eks_cluster" {
  source = "./modules/containerisation"

  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  cluster_name    = var.cluster_name
}

# Provision Security Groups
module "vpc_security_group" {
  source = "./modules/security-group"

  vpc_id = module.networking.vpc_id
}

# Provision RDS
module "rds" {
  source = "./modules/RDS"

  private_subnets       = module.networking.private_subnets
  vpc_security_group_id = [module.vpc_security_group.security-group-id]
}


resource "null_resource" "update_desired_size" {
  triggers = {
    desired_size = 3
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    # Note: this requires the awscli to be installed locally where Terraform is executed
    command = <<-EOT
      aws eks update-nodegroup-config \
        --cluster-name ${module.eks_cluster.cluster_name} \
        --nodegroup-name ${element(split(":", module.eks_cluster.eks_managed_node_groups["one"].node_group_id), 1)} \
        --scaling-config desiredSize=3 \
        --region eu-west-2
    EOT
  }
}
