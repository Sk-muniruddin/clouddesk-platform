# Currency Service Assessment


# 1. Overview

The Currency Service is responsible for converting product prices from the application's default currency into the customer's requested currency during the checkout and product browsing process. It provides exchange rate information to other backend services while ensuring pricing consistency across the platform.

The Currency Service focuses exclusively on currency conversion and does not manage product information, payments, or orders.

---

# 2. Business Purpose

The Currency Service enables customers to view product prices in their preferred currency. It improves the customer shopping experience by providing localized pricing while maintaining consistent exchange rate calculations throughout the application.

---

# 3. Responsibilities

- Receive currency conversion requests.
- Retrieve exchange rates.
- Convert product prices.
- Return converted currency values.
- Validate supported currencies.
- Handle conversion failures.
- Respond to currency requests securely.

---

# 4. Dependencies

## Upstream Consumers

- Frontend Service
- Checkout Service

## Downstream Dependencies

- Exchange Rate Data Source (Current Implementation)

> **Verified Repository Fact:** The Currency Service provides currency conversion functionality for other services during product browsing and checkout.

---

# 5. Architecture Position

The Currency Service is an internal backend microservice responsible for currency conversion. It supplies converted pricing information to the Frontend and Checkout Service, allowing customers to view prices in their selected currency.

---

# 6. Technology Stack

## Current Implementation

- Programming Language: Node.js
- Communication Protocol: gRPC
- Containerization: Docker
- Orchestration: Kubernetes

## Future Azure Design

- Azure Kubernetes Service (AKS)

---

# 7. Communication Flow

```text
Frontend
      │
      ▼
Currency Service
      ▲
      │
Checkout Service
```

---

# 8. Business Transaction Flow

```text
Receive Conversion Request
          │
          ▼
Validate Currency Code
          │
          ▼
Retrieve Exchange Rate
          │
          ▼
Convert Amount
          │
          ▼
Return Converted Price
```

---

# 9. Stateful / Stateless

**Stateless Service**

## Reason

The Currency Service processes currency conversion requests without storing application state inside the container. Each conversion request is processed independently, enabling horizontal scaling and high availability.

---

# 10. Failure Impact

If the Currency Service becomes unavailable:

- Product prices cannot be converted.
- Customers may only see default currency values.
- Checkout totals may not be calculated in the customer's selected currency.
- Customer experience is affected.

**Business Impact:** Medium

---

# 11. Hosting Strategy

## Current Implementation

- Kubernetes

## Future Azure Design

- Azure Kubernetes Service (AKS)

### Reason

Hosting the Currency Service on Kubernetes provides:

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
- Conversion Request Throughput
- Response Latency
- Error Rate

### Initial Capacity Planning (Design Decision)

- Minimum Replicas: 2
- Maximum Replicas: 10
- Autoscaling: Future Implementation

---

# 13. Exposure

**Internal Kubernetes Service (ClusterIP)**

## Reason

The Currency Service should only be accessible by trusted internal services. Customers access currency conversion indirectly through the Frontend and Checkout Service.

---

# 14. Monitoring

## Infrastructure Metrics

- CPU Utilization
- Memory Utilization
- Pod Availability
- Restart Count

## Application Metrics

- Conversion Request Rate
- Conversion Success Rate
- Conversion Failure Rate
- Response Latency
- Error Rate

## Business Metrics

- Currency Conversions Processed
- Most Requested Currencies
- Failed Currency Requests

---

# 15. Logging

The service should log:

- Currency Conversion Requests
- Exchange Rate Retrieval
- Invalid Currency Codes
- Conversion Errors
- Timeout Events
- Retry Attempts
- gRPC Communication Errors
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

If a Currency Service pod fails:

- Kubernetes automatically recreates the failed pod.

If an AKS node fails (Future Azure Design):

- AKS schedules the pod onto another healthy node.

If exchange rate retrieval fails:

- Retry the request.
- Return the default currency when appropriate.
- Log the failure for investigation.

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

- Integrate with real-time exchange rate providers.
- Cache exchange rates to improve performance.
- Automatically refresh exchange rates.
- Support historical exchange rates.
- Add distributed tracing using OpenTelemetry.
- Improve monitoring and alerting.
- Introduce AI-based exchange rate prediction.