data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.vpc_name

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

# resource "aws_internet_gateway" "IGW" { # Creating Internet Gateway
#   vpc_id = module.vpc.vpc_id              # vpc_id will be generated after we create VPC
# }

# resource "aws_route_table" "PublicRT-1" { # Creating RT for Public Subnet
#   vpc_id = module.vpc.vpc_id
#   route {
#     cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
#     gateway_id = aws_internet_gateway.IGW.id
#   }
# }

# resource "aws_route_table_association" "PrivateRTassociation" {
  
#   subnet_id =module.VPC.private_subnets[*].id
#   route_table_id = aws_route_table.PublicRT-1.id
# }