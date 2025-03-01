terraform {
  required_version = ">= 1.5.0"
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}

data "google_client_config" "default" {}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a local for the cluster auth to avoid repetition
locals {
  cluster_auth = {
    host                   = "https://${module.gke.cluster_endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = local.cluster_auth.host
  token                  = local.cluster_auth.token
  cluster_ca_certificate = local.cluster_auth.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = local.cluster_auth.host
    token                  = local.cluster_auth.token
    cluster_ca_certificate = local.cluster_auth.cluster_ca_certificate
  }
}