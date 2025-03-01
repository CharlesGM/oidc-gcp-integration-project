# OIDC, GitHub Actions, GCP Integration Project 🚀 
A complete CI/CD pipeline with GKE, GitHub Actions, and Terraform using Workload Identity Federation. 🔄
The aim of this project is to showcase how you can use GCP's workload identinty for your CI/CD with Github Actions.

Additional components like Argo and Crossplane are just for plays-sake.

## Prerequisites ✅
- GCP Account
- GitHub Repository
- Terraform installed
- gcloud CLI

## Project Structure 📁

      ├── Dockerfile
      ├── README.md
      ├── app.py
      ├── argocd
      │   ├── application.yaml
      │   └── argo.yaml
      ├── ledgerndary-helm
      │   ├── Chart.yaml
      │   ├── templates
      │   │   ├── deployment.yaml
      │   │   ├── rbac.yaml
      │   │   └── service.yaml
      │   └── values.yaml
      ├── crossplane.yaml
      ├── requirements.txt
      └── terraform
            ├── backend.tf
            ├── main.tf
            ├── modules
            │   ├── artifact-registry
            │   │   ├── main.tf
            │   │   ├── outputs.tf
            │   │   └── variables.tf
            │   ├── gke
            │   │   ├── main.tf
            │   │   ├── outputs.tf
            │   │   └── variables.tf
            │   └── vpc
            │       ├── main.tf
            │       ├── outputs.tf
            │       └── variables.tf
            ├── outputs.tf
            ├── provider.tf
            ├── sp.auto.tfvars
            ├── terraform.tfvars
            └── variables.tf

## Infrastructure Overview 🏗️

### Components
- GKE Cluster
- Artifact Registry
- VPC Network
- Workload Identity Federation
- RBAC Configuration
- ArgoCD

### Infrastructure Details 🌐

#### VPC Configuration 🔌
- Custom VPC with secondary IP ranges
- Private GKE cluster setup
- Firewall rules for cluster access

#### GKE Configuration 🎛️
- Private cluster with public endpoint
- Node pool with autoscaling
- Workload Identity enabled
- Network policies enabled

#### Security Features 🔒
- Workload Identity Federation for keyless authentication
- RBAC for Kubernetes access control
- Private GKE cluster
- Limited service account permissions

## Deployment Process 🚀

### 1. Initial Setup 🛠️

#### Create GCP Project and enable APIs ⚡

      gcloud projects create PROJECT_ID
      gcloud services enable container.googleapis.com artifactregistry.googleapis.com

#### Configure Terraform backend 💾
Create storage bucket for Terraform state:

      gsutil mb gs://ledgerndarytfstate

#### Initialize Terraform 🎮

      terraform init
      terraform apply

#### Configure GitHub Secrets 🔐

      GCP_WORKLOAD_IDENTITY_PROVIDER
      GCP_SERVICE_ACCOUNT
      AUDIENCE
      TOKEN_GITHUB


### 2. Application Setup 💻

#### Application Specifications
Simple Python Flask application deployed with:
- Node pool: e2-small (1 node)
- Disk size: 30GB
- Region: europe-west1

#### ArgoCD Setup 🎯
ArgoCD is installed automatically via Terraform. After infrastructure is deployed:

1. Access ArgoCD UI:

         kubectl port-forward svc/argocd-server -n argocd 8080:443

2. Get initial admin password:

         kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

3. Access UI at: https://localhost:8080
- Username: admin
- Password: (from step 2)

### 3. Pipeline Configuration

#### GitOps Pipeline 🔄
The complete pipeline:
- Push to main triggers GitHub Actions
- Builds Docker image
- Pushes to Artifact Registry
- Updates Helm values with new image tag
- ArgoCD detects changes
- ArgoCD automatically deploys to GKE

#### GitHub Actions Configuration ⚙️
Required Secrets:

      1. GCP_WORKLOAD_IDENTITY_PROVIDER: Full Workload Identity Provider path
      2. GCP_SERVICE_ACCOUNT: Service account email
      3. AUDIENCE: https://token.actions.githubusercontent.com
      4. TOKEN_GITHUB: GitHub token for repository access

### 4. Terraform Configuration

#### Variables and State Management ⚙️
Key variables in terraform.tfvars:

      vpc_name                      = "ledgerndary-vpc"
      subnet_name                   = "ledgerndary-subnet"
      subnet_cidr                   = "10.0.0.0/24"
      pod_cidr                      = "10.16.0.0/24"
      service_cidr                  = "10.32.0.0/24"
      cluster_name                  = "ledgerndary-cluster"

Key variables in sp.auto.tfvars:

      project_id                    = "project-id"
      region                        = "region"
      workload_identity_pool_id     = "xxxxxx-xxxxxxx-xxxxxx"
      workload_identity_provider_id = "xxxxxx-xxxxxxx-xxxxxx"
      github_repo                   = "xxxxxx-xxxxxxx-xxxxxx"
      project_owner_email          = "xxxxxx-xxxxxxx-xxxxxx"

#### Variable Precedence Order
Terraform loads variables in the following order (highest to lowest priority):
- CLI arguments (-var="name=value" or -var-file=custom.tfvars)
- Environment variables (TF_VAR_name=value)
- terraform.tfvars file (explicitly recognized and loaded)
- *.auto.tfvars files (including sp.auto.tfvars)
- Default values in variables.tf

#### State Configuration 💾
State is stored in Google Cloud Storage:

      terraform {
            backend "gcs" {
               bucket = "ledgerndarytfstate"
               prefix = "terraform/state"
            }
      }

## Authentication and Security 🔑

### Authentication Methods

#### 1. Workload Identity Federation
What it is: Allows GitHub Actions to authenticate to GCP without storing service account keys \
How it works:

- Uses OpenID Connect (OIDC) tokens from GitHub Actions
- Exchanges OIDC tokens for GCP access tokens
- No long-lived credentials stored in GitHub

      # Set up GCP authentication using Workload Identity Federation
      - id: 'auth'
         name: 'Authenticate to Google Cloud'
         uses: 'google-github-actions/auth@v1'
         with:
            workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }}
            service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}
            token_format: 'access_token'
            audience: ${{ secrets.AUDIENCE }}

#### 2. Service Account Keys (Traditional Method)

What it is: JSON key file for service account authentication \
Drawbacks:

- Long-lived credentials stored in GitHub Secrets
- Need to rotate keys regularly
- Security risk if keys are compromised

       # GitHub Actions example
       - uses: 'google-github-actions/auth@v1'
         with:
           credentials_json: ${{ secrets.GCP_SA_KEY }}

#### 3. Application Default Credentials
What it is: Local authentication method \
Drawbacks:

- Only works for local development
- Not suitable for CI/CD
- Requires gcloud login

## Operations and Maintenance 🔧

### Usage 📋
- Push to main branch triggers workflow
- Monitor GitHub Actions
- Check GKE deployment:

       kubectl get pods -n ledgerndary

### Verification ✅
Check deployment status:

      # View ArgoCD application status
      kubectl get applications -n argocd

      # Check pods in application namespace
      kubectl get pods -n ledgerndary

      # View deployment history
      kubectl rollout history deployment/ledgerndary -n ledgerndary

### Troubleshooting 🔧

#### 1. Authentication Issues:

      # Verify Workload Identity setup
      gcloud iam workload-identity-pools providers describe ledgerndary-gh-provider --location="global" --workload-identity-pool="ledgerndary-gh-pool"

#### 2. GKE Access Issues:

      # Update kubeconfig
      gcloud container clusters get-credentials ledgerndary-cluster --region europe-west1 --project play-project-325908

### Maintenance Tasks 🔄
- Monitor GKE logs
- Check Artifact Registry storage
- Review RBAC permissions periodically
- Update dependencies as needed

## Notes 📝
- Workload Identity eliminates need for stored credentials
- Uses GCP Artifact Registry for container images
- Helm manages Kubernetes deployments
- RBAC configured for least privilege access

For detailed setup instructions, refer to individual component comments/documentation.