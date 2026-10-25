module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "../../modules/security"

  environment  = var.environment
  cluster_name = var.cluster_name
}

module "eks" {
  source = "../../modules/eks"

  environment         = var.environment
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  subnet_ids          = module.vpc.private_subnet_ids
  cluster_role_arn    = module.security.cluster_role_arn
  node_role_arn       = module.security.node_role_arn
  kms_key_arn         = module.security.kms_key_arn
  node_instance_types = var.node_instance_types
  desired_nodes       = var.desired_nodes
  min_nodes           = var.min_nodes
  max_nodes           = var.max_nodes
}
