output "repository_id" {
  value = google_artifact_registry_repository.repository.id
}

output "repository_name" {
  value = google_artifact_registry_repository.repository.repository_id
}

output "location" {
  value = google_artifact_registry_repository.repository.location
}