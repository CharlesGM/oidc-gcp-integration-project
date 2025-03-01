# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.vpc.subnet_id
}

output "cluster_endpoint" {
  description = "The IP address of the cluster's Kubernetes master"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The public certificate authority of the cluster"
  value       = module.gke.cluster_ca_certificate
  sensitive   = true
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.cluster_name
}

# Artifact Registry outputs
output "repository_id" {
  description = "The ID of the Artifact Registry repository"
  value       = module.artifact_registry.repository_id
}

output "repository_url" {
  description = "The URL of the Artifact Registry repository"
  value       = "${module.artifact_registry.location}-docker.pkg.dev/${var.project_id}/${module.artifact_registry.repository_name}"
}

output "workload_identity_provider" {
  description = "Workload Identity Provider resource path"
  value       = module.gke.workload_identity_provider
}

output "service_account_email" {
  description = "Email of the created Google Service Account"
  value       = module.gke.service_account_email
}

output "gke_workload_identity_provider_path" {
  description = "The full path of the Workload Identity Pool Provider"
  value       = module.gke.workload_identity_provider_path
}

output "gke_provider_id_string" {
  description = "The full provider ID string for GitHub Actions"
  value       = module.gke.provider_id_string
}