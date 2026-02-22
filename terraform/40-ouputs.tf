output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "selected_availability_zones" {
  description = "Availability Zones used for the VPC and EKS"
  value       = local.azs
}