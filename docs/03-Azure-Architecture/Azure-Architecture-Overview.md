# Azure Architecture Overview

## Overview

The CloudDesk Commerce Platform is deployed on Microsoft Azure using a cloud-native microservices architecture. The platform is designed for high availability, scalability, security, and operational excellence.

The application consists of multiple containerized microservices deployed on Azure Kubernetes Service (AKS). Supporting Azure services provide container image storage, secret management, caching, networking, monitoring, governance, and security.

---

## Architecture Goals

- High Availability
- Horizontal Scalability
- Secure Communication
- Centralized Monitoring
- Disaster Recovery
- Cost Optimization
- Enterprise Security

---

## Core Azure Services

- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Application Gateway
- Azure Web Application Firewall (WAF)
- Azure Key Vault
- Azure Cache for Redis
- Azure Monitor
- Log Analytics Workspace
- Application Insights
- Azure Policy
- Azure RBAC
- Microsoft Defender for Cloud

---

## High-Level Request Flow

Internet
→ Azure DNS
→ Azure Application Gateway
→ AKS
→ Microservices
→ Azure Key Vault / Azure Cache for Redis

---

## Architecture Principles

- Container-first deployment
- Managed Azure services
- Least privilege access
- Private connectivity
- Infrastructure as Code
- Centralized monitoring