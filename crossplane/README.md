# Step 1: Install required tools

## 1a. Install Crossplane using Helm:

    helm repo add crossplane-stable https://charts.crossplane.io/stable
    helm repo update
    helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace --set image.repository=docker.io/crossplane/crossplane --set image.tag=v1.19.0

## 1b. Wait for Crossplane pods to be ready:

    kubectl wait --for=condition=ready pod -l app=crossplane --namespace crossplane-system --timeout=300s

# Step 2: Create GCP Service Account credentials

## 2a. Create a Service Account and download credentials:

    export PROJECT_ID="play-project-325908"
    export SA_NAME="crossplane-sa"
    
    gcloud iam service-accounts create $SA_NAME --project=$PROJECT_ID --display-name="Crossplane Service Account"

    gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.admin"

    gcloud iam service-accounts keys create credentials.json --project=$PROJECT_ID --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
 
## 2b. Create Kubernetes secret with GCP credentials:

    kubectl create secret generic gcp-creds --from-file=credentials.json --namespace crossplane-system

1. Apply provider

        kubectl create -f 1-provider.yaml

2. Wait for provider to be healthy

        kubectl wait --for=condition=healthy provider.pkg.crossplane.io/crossplane-provider-gcp -n crossplane-system --timeout=180s
        kubectl get providers.pkg.crossplane.io -n crossplane-system -w         # wait for health = true, installed = true


3. Apply provider config

        kubectl create -f 2-provider-config.yaml

4. Apply bucket

        kubectl create -f 3-bucket.yaml

#### Useful commands:

        kubectl delete provider.pkg.crossplane.io/crossplane-provider-gcp -n crossplane-system


## Setup Cloud NAT

        export REGION=europe-west1              # GKE cluster's region
        export NETWORK=ledgerndary-vpc        # VPC network name

#### Create Cloud Router

        gcloud compute routers create crossplane-nat-router --network=$NETWORK --region=$REGION

#### Create Cloud NAT

        gcloud compute routers nats create crossplane-nat-config --router=crossplane-nat-router --router-region=$REGION --nat-all-subnet-ip-ranges --auto-allocate-nat-external-ips
