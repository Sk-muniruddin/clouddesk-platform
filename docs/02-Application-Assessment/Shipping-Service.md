# Shipping Service Assessment


---

# 1. Overview

The Shipping Service is responsible for calculating shipping costs during the customer checkout process. It receives shipping requests from the Checkout Service, calculates the shipping charges based on the destination and order details, and returns the shipping cost required to complete the customer's purchase.

The Shipping Service focuses solely on shipping cost calculation and does not process payments, manage orders, or perform shipment tracking.

---

# 2. Business Purpose

The Shipping Service enables accurate shipping cost estimation before an order is placed. It ensures customers are presented with the correct shipping charges during checkout, allowing the business to calculate the total order value before payment is processed.

---

# 3. Responsibilities

- Receive shipping calculation requests.
- Calculate shipping costs.
- Return shipping quotations.
- Validate shipping destination information.
- Handle shipping calculation failures.
- Respond to shipping requests securely.

---

# 4. Dependencies

## Upstream Consumers

- Checkout Service

## Downstream Dependencies

- None (Current Implementation)

> **Verified Repository Fact:** The Shipping Service is called by the Checkout Service to calculate shipping costs before payment processing.

---

# 5. Architecture Position

The Shipping Service is an internal backend microservice responsible for providing shipping cost calculations during the checkout workflow. It supplies shipping information required by the Checkout Service before completing customer purchases.

---

# 6. Technology Stack

## Current Implementation

- Programming Language: Go
- Communication Protocol: gRPC
- Containerization: Docker
- Orchestration: Kubernetes

## Future Azure Design

- Azure Kubernetes Service (AKS)

---

# 7. Communication Flow

```text
Checkout Service
        │
        ▼
 Shipping Service
        │
        ▼
Shipping Cost Response
```

---

# 8. Business Transaction Flow

```text
Receive Shipping Request
          │
          ▼
Validate Destination
          │
          ▼
Calculate Shipping Cost
          │
          ▼
Return Shipping Quote
          │
          ▼
Checkout Service Continues
```

---

# 9. Stateful / Stateless

**Stateless Service**

## Reason

The Shipping Service processes shipping calculation requests without storing application state inside the container. Each request is handled independently, allowing multiple instances to process requests simultaneously while supporting horizontal scaling and high availability.

---

# 10. Failure Impact

If the Shipping Service becomes unavailable:

- Shipping costs cannot be calculated.
- Checkout cannot determine the final order amount.
- Customers cannot complete purchases.
- Revenue generation is impacted.

**Business Impact:** High

---

# 11. Hosting Strategy

## Current Implementation

- Kubernetes

## Future Azure Design

- Azure Kubernetes Service (AKS)

### Reason

Hosting the Shipping Service on Kubernetes provides:

- High Availability
- Self-Healing
- Rolling Updates
- Horizontal Scaling
- Fault Tolerance

---

# 12. Scaling Strategy

Horizontal scaling using Kubernetes replicas and the Horizontal Pod Autoscaler (HPA).

### Scaling Metrics

- CPU Utilization
- Memory Utilization
- Shipping Request Throughput
- Shipping Response Latency
- Error Rate

### Initial Capacity Planning (Design Decision)

- Minimum Replicas: 2
- Maximum Replicas: 10
- Autoscaling: Future Implementation

---

# 13. Exposure

**Internal Kubernetes Service (ClusterIP)**

## Reason

The Shipping Service should only be accessible by trusted internal services within the Kubernetes cluster. External users access shipping functionality indirectly through the Checkout Service.

---

# 14. Monitoring

## Infrastructure Metrics

- CPU Utilization
- Memory Utilization
- Pod Availability
- Restart Count

## Application Metrics

- Shipping Request Rate
- Shipping Success Rate
- Shipping Failure Rate
- Average Response Latency
- Error Rate

## Business Metrics

- Shipping Quotes Generated
- Failed Shipping Calculations
- Average Shipping Cost
- Request Volume

---

# 15. Logging

The service should log:

- Shipping Requests
- Shipping Cost Calculations
- Validation Failures
- Calculation Errors
- Timeout Events
- Retry Attempts
- gRPC Communication Errors
- Distributed Trace IDs
- Startup Events
- Health Probe Results
- Application Errors

---

# 16. Security

## Current Implementation

- Restrict external access.
- Encrypt service-to-service communication.
- Validate incoming requests.
- Apply least-privilege access controls.
- Enable centralized logging and auditing.

## Future Azure Design

- Azure Key Vault
- Azure Managed Identity
- Azure RBAC
- Private Networking

---

# 17. Recovery Strategy

If a Shipping Service pod fails:

- Kubernetes automatically recreates the failed pod.

If an AKS node fails (Future Azure Design):

- AKS schedules the pod onto another healthy node.

If shipping calculations fail:

- Retry the calculation when appropriate.
- Return a meaningful error response.
- Allow the Checkout Service to decide whether to retry or fail the transaction.

Deployment Strategy:

- Rolling Updates
- Zero-Downtime Deployments

---

# 18. Service Availability Requirements

| Requirement | Target |
|------------|--------|
| Availability | 99.9% |
| Deployment Strategy | Rolling Updates |
| High Availability | Multiple Replicas |
| Recovery Time Objective (RTO) | Less than 15 Minutes |
| Recovery Point Objective (RPO) | Near Zero |

---

# 19. Future Improvements

- Integrate with real shipping providers.
- Support multiple shipping methods.
- Calculate shipping based on package dimensions and weight.
- Add international shipping support.
- Implement distributed tracing using OpenTelemetry.
- Improve monitoring and alerting.
- Introduce AI-based shipping cost optimization.