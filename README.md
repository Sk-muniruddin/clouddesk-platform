# CloudDesk Platform — Azure Cloud & DevOps

Production-style Azure Cloud and DevOps implementation for a containerized microservices application.

The application was provided by the development team. This project focuses on the **Cloud/DevOps engineering lifecycle**:

```text
Developer Source Code + Dockerfiles
              │
              ▼
          Docker Build
              │
              ▼
       Azure Container Registry
              │
              ▼
     Azure Kubernetes Service
              │
              ▼
       Kubernetes Workloads
              │
              ▼
       Public Application
              │
              ▼
     Monitoring & Operations
```

---

## Project Overview

CloudDesk is deployed using modern cloud-native technologies and Infrastructure as Code.

### Cloud Platform

* Microsoft Azure
* Azure Resource Group
* Azure Container Registry (ACR)
* Azure Kubernetes Service (AKS)
* Microsoft Entra ID
* Azure RBAC

### Infrastructure as Code

* Terraform
* AzureRM provider
* AzureAD provider
* Terraform-managed Azure resources
* Terraform-managed GitHub OIDC identities

### Containerization

* Docker
* Developer-provided Dockerfiles
* Versioned container images
* Azure Container Registry

### Kubernetes

* Azure Kubernetes Service
* Kubernetes Deployments
* Kubernetes Services
* Kubernetes namespace
* Kubernetes health probes
* Azure LoadBalancer

### CI/CD

* GitHub Actions
* GitHub OIDC authentication
* Application CI
* Application CD
* Immutable Git SHA image tags
* AKS deployment automation

---

# Architecture

```text
                         GitHub Repository
                                │
              ┌─────────────────┴─────────────────┐
              │                                   │
              ▼                                   ▼
      Application CI                    Infrastructure CI/CD
              │                                   │
              ▼                                   ▼
       Docker Build                         Terraform
              │                                   │
              ▼                                   ▼
       Security / Tests                    Azure Resources
              │
              ▼
       Azure Container
          Registry
              │
              │ Image
              ▼
       Azure Kubernetes
           Service
              │
       ┌──────┴──────┐
       │             │
       ▼             ▼
 Kubernetes       Azure
 Services        LoadBalancer
       │             │
       └──────┬──────┘
              ▼
        Public Frontend
```

---

# Application Microservices

The repository contains the following deployable services:

| Service               | Runtime |  Port | Protocol |
| --------------------- | ------- | ----: | -------- |
| frontend              | Go      |  8080 | HTTP     |
| adservice             | Java    |  9555 | gRPC     |
| cartservice           | .NET    |  7070 | gRPC     |
| checkoutservice       | Go      |  5050 | gRPC     |
| currencyservice       | Node.js |  7000 | gRPC     |
| emailservice          | Python  |  8080 | gRPC     |
| paymentservice        | Node.js | 50051 | gRPC     |
| productcatalogservice | Go      |  3550 | gRPC     |
| recommendationservice | Python  |  8080 | gRPC     |
| shippingservice       | Go      | 50051 | gRPC     |

The Kubernetes configuration uses Kubernetes DNS names for internal service-to-service communication.

Example:

```text
frontend
   │
   ├── productcatalogservice:3550
   ├── currencyservice:7000
   ├── cartservice:7070
   ├── recommendationservice:8080
   ├── checkoutservice:5050
   ├── shippingservice:50051
   └── adservice:9555
```

---

# Repository Structure

```text
clouddesk-platform/
│
├── .github/
│   └── workflows/
│       ├── docker-to-acr.yml
│       └── cd-to-aks.yml
│
├── k8s/
│   └── microservices.yaml
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── aks.tf
│   ├── github-oidc.tf
│   ├── github-cd-oidc.tf
│   ├── terraform.tfvars
│   └── .terraform.lock.hcl
│
├── services/
│   ├── frontend/
│   ├── adservice/
│   ├── cartservice/
│   ├── checkoutservice/
│   ├── currencyservice/
│   ├── emailservice/
│   ├── paymentservice/
│   ├── productcatalogservice/
│   ├── recommendationservice/
│   └── shippingservice/
│
└── README.md
```

Terraform state files and provider binaries are intentionally excluded from Git.

---

# Azure Infrastructure

Terraform provisions the Azure infrastructure.

Current environment:

```text
Resource Group:
rg-clouddesk-devops

Region:
Central India

Azure Container Registry:
clouddeskacr

ACR Login Server:
clouddeskacr.azurecr.io

Azure Kubernetes Service:
aks-clouddesk
```

AKS uses a system-assigned managed identity.

The AKS kubelet identity is granted:

```text
AcrPull
```

on the Azure Container Registry.

This allows Kubernetes nodes to pull private images from ACR without enabling ACR administrator credentials.

---

# Terraform

Terraform is responsible for infrastructure rather than application deployment.

Main lifecycle:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

To remove the infrastructure when appropriate:

```bash
terraform destroy
```

Terraform manages:

* Azure Resource Group
* Azure Container Registry
* AKS
* AKS identity
* ACR pull permissions
* GitHub OIDC identities
* Azure RBAC assignments

The AzureRM provider is pinned to the project-approved version.

---

# Container Registry

Azure Container Registry is used as the private image registry.

```text
Docker Build
     │
     ▼
Azure Container Registry
     │
     ├── frontend
     ├── adservice
     ├── cartservice
     ├── checkoutservice
     ├── currencyservice
     ├── emailservice
     ├── paymentservice
     ├── productcatalogservice
     ├── recommendationservice
     └── shippingservice
```

The intended image convention is:

```text
clouddeskacr.azurecr.io/<service>:<git-sha>
```

Example:

```text
clouddeskacr.azurecr.io/frontend:<commit-sha>
```

Immutable Git SHA tags prevent deployments from silently changing when the `latest` tag is overwritten.

---

# Application CI

Application CI is implemented using GitHub Actions.

Workflow:

```text
Git Push
   │
   ▼
GitHub Actions
   │
   ▼
Checkout source
   │
   ▼
Docker Build
   │
   ▼
Version image using Git SHA
   │
   ▼
Azure Container Registry
```

Workflow file:

```text
.github/workflows/docker-to-acr.yml
```

The workflow uses a matrix strategy to build the microservices independently.

The intended registry flow is:

```text
GitHub
  │
  ▼
Docker Build
  │
  ▼
ACR
```

The GitHub workflow uses Azure OIDC rather than storing a long-lived Azure client secret for authentication.

---

# Application CD

Application CD is separated from application CI.

Workflow:

```text
Successful CI
      │
      ▼
ACR image
      │
      ▼
GitHub CD
      │
      ▼
Azure authentication
      │
      ▼
AKS credentials
      │
      ▼
kubectl apply
      │
      ▼
Kubernetes Deployment
      │
      ▼
Pods
```

CD workflow:

```text
.github/workflows/cd-to-aks.yml
```

The CD workflow is triggered after successful completion of the application CI workflow.

The deployment uses the exact Git commit SHA associated with the successful CI run.

---

# Kubernetes

Kubernetes resources are stored under:

```text
k8s/
```

Main manifest:

```text
k8s/microservices.yaml
```

The manifest defines:

* Namespace
* Deployments
* ClusterIP Services
* Frontend LoadBalancer Service
* Container ports
* Service-to-service environment variables
* Frontend health probes

Application namespace:

```text
clouddesk
```

Example internal Kubernetes communication:

```text
frontend
   │
   ▼
productcatalogservice:3550
```

Kubernetes DNS resolves:

```text
productcatalogservice
```

to the corresponding Kubernetes Service.

---

# Public Endpoint

The frontend is exposed using an Azure LoadBalancer-backed Kubernetes Service.

```yaml
kind: Service
type: LoadBalancer
```

Traffic flow:

```text
Internet
   │
   ▼
Azure LoadBalancer
   │
   ▼
frontend Service
   │
   ▼
frontend Pod
```

The frontend container listens on:

```text
8080
```

The Kubernetes Service exposes:

```text
80
```

---

# Health Checks

The frontend exposes:

```text
/_healthz
```

Kubernetes uses this endpoint for:

* Readiness
* Liveness

Example:

```yaml
readinessProbe:
  httpGet:
    path: /_healthz
    port: 8080

livenessProbe:
  httpGet:
    path: /_healthz
    port: 8080
```

This allows Kubernetes to distinguish between:

```text
Pod exists
```

and:

```text
Application is actually ready
```

---

# Security

Security principles used in the project:

### No ACR admin credentials

ACR administrator authentication is disabled.

AKS uses:

```text
Managed Identity
       │
       ▼
     AcrPull
       │
       ▼
      ACR
```

### GitHub OIDC

GitHub Actions authenticates to Azure using federated identity rather than storing a permanent Azure password.

### Least privilege

The intended separation is:

```text
CI Identity
    │
    └── AcrPush

AKS Identity
    │
    └── AcrPull

CD Identity
    │
    └── AKS deployment permissions
```

### Secrets

Sensitive Terraform values and environment-specific values are excluded from Git.

---

# Verification Commands

Check AKS:

```bash
az aks show \
  --resource-group rg-clouddesk-devops \
  --name aks-clouddesk
```

Connect to AKS:

```bash
az aks get-credentials \
  --resource-group rg-clouddesk-devops \
  --name aks-clouddesk \
  --overwrite-existing
```

Check nodes:

```bash
kubectl get nodes
```

Check system workloads:

```bash
kubectl get pods -A
```

Check application:

```bash
kubectl get deployments -n clouddesk
kubectl get pods -n clouddesk
kubectl get services -n clouddesk
```

Check rollout:

```bash
kubectl rollout status deployment/frontend -n clouddesk
```

Inspect failed workloads:

```bash
kubectl describe pod <pod-name> -n clouddesk
```

View logs:

```bash
kubectl logs <pod-name> -n clouddesk
```

---

# Troubleshooting

## ImagePullBackOff

Check:

```bash
kubectl describe pod <pod-name> -n clouddesk
```

Verify:

```text
ACR image exists
        +
correct image tag
        +
AKS identity has AcrPull
```

## CrashLoopBackOff

Check:

```bash
kubectl logs <pod-name> -n clouddesk
```

Then:

```bash
kubectl describe pod <pod-name> -n clouddesk
```

Investigate:

* Environment variables
* Service addresses
* Application startup errors
* Port configuration
