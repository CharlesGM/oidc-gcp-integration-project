# Project and Region Configuration
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "environment" {
  description = "Environment (prod, staging, dev)"
  type        = string
  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be one of: prod, staging, dev."
  }
}

# GKE Cluster Configuration
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for GKE master"
  type        = string
  default     = "172.16.0.0/28"
}

variable "authorized_networks" {
  description = "List of authorized networks for GKE master"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

# Node Pool Configuration
variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-small"
}

variable "disk_size_gb" {
  description = "Disk size for nodes in GB"
  type        = number
  default     = 30
}

# Workload Identity Configuration
variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "ledgerndary-github-pool"
}

variable "workload_identity_provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
  default     = "ledgerndary-github-provider"
}

# GitHub and Repository Configuration
variable "github_repo" {
  description = "GitHub repository in format owner/repository"
  type        = string
}

variable "helm_chart_path" {
  description = "Path to Helm chart in repository"
  type        = string
  default     = "ledgerndary-helm"
}

# Access Control
variable "gke_admins" {
  description = "List of GKE administrators"
  type        = list(string)
  default     = []
}

variable "project_owner_email" {
  description = "Email of the project owner"
  type        = string
}

# Namespace Configuration
variable "namespace" {
  description = "Namespace for application deployment"
  type        = string
  default     = "ledgerndary"
}


variable "max_node_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
  default     = 5
}

# Optional: For private repository
variable "github_username" {
  description = "GitHub username for repository access"
  type        = string
  default     = ""
}

variable "github_token" {
  description = "GitHub token for repository access"
  type        = string
  default     = ""
  sensitive   = true
}