module "vpc" {
  source = "./modules/vpc"

  vpc_name     = var.vpc_name
  subnet_name  = var.subnet_name
  subnet_cidr  = var.subnet_cidr
  pod_cidr     = var.pod_cidr
  service_cidr = var.service_cidr
  region       = var.region
}

module "gke" {
  source                        = "./modules/gke"
  project_id                    = var.project_id
  workload_identity_pool_id     = var.workload_identity_pool_id
  workload_identity_provider_id = var.workload_identity_provider_id
  github_repo                   = var.github_repo
  cluster_name                  = var.cluster_name
  region                        = var.region
  network_name                  = module.vpc.network_name
  subnet_name                   = module.vpc.subnet_name
  environment                   = var.environment
  node_count                    = var.node_count
  machine_type                  = var.machine_type
  disk_size_gb                  = var.disk_size_gb
  project_owner_email           = var.project_owner_email
  max_node_count                = var.max_node_count
  github_username               = var.github_username
  github_token                  = var.github_token
  master_ipv4_cidr_block        = var.master_ipv4_cidr_block
  authorized_networks           = var.authorized_networks
  gke_admins                    = var.gke_admins
  namespace                     = var.namespace

  depends_on = [module.vpc]
}

module "artifact_registry" {
  source = "./modules/artifact-registry"

  region          = var.region
  repository_name = var.repository_name
}