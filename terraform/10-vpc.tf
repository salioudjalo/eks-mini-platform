data "aws_availability_zones" "available" {
  state = "available"

  # Only "real" AZs (excludes Local Zones like us-east-1-bos-1a)
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

locals {
  azs = slice(sort(data.aws_availability_zones.available.names), 0, 2)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = var.project_name
  cidr = "10.0.0.0/16"

  azs             = local.azs
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Project = var.project_name
  }
}