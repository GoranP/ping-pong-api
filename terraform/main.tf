# use AWS official provider
provider "aws" {
  region = "eu-west-2"
}

# Create AWS VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "pingpong-vpc"

  cidr = "10.0.0.0/16"

  # minumum 2 zones for better availability
  azs  = ["eu-west-2a","eu-west-2b"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/ping-pong-cluster" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/ping-pong-cluster" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

# create kubernetes cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "ping-pong-cluster"
  cluster_version = "1.29"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true
  authentication_mode = "API_AND_CONFIG_MAP"

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-pingpong"

      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 4
      desired_size = 2
    }
  }
}

