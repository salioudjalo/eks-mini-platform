module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.project_name
  kubernetes_version = "1.35"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # Install networking + core addons BEFORE node groups
  addons = {
    vpc-cni = {
      before_compute              = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {
      before_compute = true
    }
    coredns = {
      before_compute = true
    }
  }

  # EC2 workers that run pods. This is what eks_managed_node_groups creates.
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.small"] # Free tier eligible 
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      iam_role_attach_cni_policy = true
    }
  }

  tags = {
    Project = var.project_name
  }
}