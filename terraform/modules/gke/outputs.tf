output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "workload_identity_provider" {
  description = "Workload Identity Provider resource path"
  value       = "projects/${var.project_id}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.github.workload_identity_pool_provider_id}"
}

output "service_account_email" {
  description = "Email of the created Google Service Account"
  value       = google_service_account.github_actions.email
}

output "kubernetes_service_account" {
  description = "Name of the Kubernetes Service Account"
  value       = kubernetes_service_account.github_actions.metadata[0].name
}

output "kubernetes_namespace" {
  description = "Namespace of the Kubernetes Service Account"
  value       = kubernetes_service_account.github_actions.metadata[0].namespace
}

output "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  value       = google_iam_workload_identity_pool.github.workload_identity_pool_id
}

output "workload_identity_provider_path" {
  description = "The full path of the Workload Identity Pool Provider"
  value       = "${google_iam_workload_identity_pool_provider.github.name}"
}

output "provider_id_string" {
  description = "The full provider ID string for GitHub Actions"
  value       = "projects/${var.project_id}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/providers/${var.workload_identity_provider_id}"
}