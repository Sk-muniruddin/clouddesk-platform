# Cart Service Assessment

## 1. Overview

The Cart Service is responsible for managing customer shopping carts within the CloudDesk Commerce Platform. It processes cart-related requests such as adding products, updating quantities, removing items, and retrieving the current shopping cart. The service works together with Redis, which stores the shopping cart data.

---

## 2. Business Purpose

The Cart Service enables customers to build and manage their shopping cart before proceeding to checkout. It provides a seamless shopping experience by allowing users to add, update, remove, and view products selected for purchase.

---

## 3. Responsibilities

- Create shopping carts.
- Add products to customer carts.
- Update product quantities.
- Remove products from customer carts.
- Retrieve customer cart information.
- Manage shopping cart operations.
- Communicate with Redis for cart persistence.
- Respond to cart-related requests from authorized services.

---

## 4. Dependencies

### Upstream Consumers

- Frontend Service
- Checkout Service

### Downstream Dependencies

- Redis

> **Verified Repository Fact:** The Cart Service relies on Redis to store and retrieve shopping cart data.

---

## 5. Architecture Position

The Cart Service is an internal backend microservice responsible for handling shopping cart operations. It receives requests from the Frontend, processes cart-related actions, stores and retrieves cart data through Redis, and provides cart information to the Checkout Service during order processing.

---

## 6. Technology Stack

- Programming Language: C#
- Communication Protocol: gRPC
- External Data Store: Redis
- Containerization: Docker
- Orchestration: Kubernetes
- Future Cloud Platform: Azure Kubernetes Service (AKS)

---

## 7. Stateful / Stateless

**Stateless Service with External Stateful Storage**

### Reason

The Cart Service itself does not permanently store shopping cart data inside the application container. Instead, shopping cart data is stored in Redis. Because the application state is maintained outside the service, multiple Cart Service instances can process requests independently while sharing the same centralized data store. This enables horizontal scaling, high availability, and fault tolerance.

---

## 8. Failure Impact

If the Cart Service becomes unavailable:

- Customers cannot add products to their shopping cart.
- Existing carts cannot be viewed or modified.
- Checkout cannot continue successfully.
- Customers may abandon purchases.

**Business Impact:** Critical

---

## 9. Hosting Strategy

### Current Application

- Kubernetes
- Redis

### Future Azure Design

- Azure Kubernetes Service (AKS)
- Azure Cache for Redis

### Reason

The Cart Service is containerized and benefits from Kubernetes features such as:

- High Availability
- Self-Healing
- Rolling Updates
- Horizontal Scaling

Azure Cache for Redis will provide a managed, highly available, and low-latency data store for shopping cart data.

---

## 10. Scaling Strategy

Horizontal scaling using Kubernetes replicas and the Horizontal Pod Autoscaler (HPA).

Scaling metrics include:

- CPU utilization
- Memory utilization
- Request throughput
- Request latency

### Initial Capacity Planning (Design Decision)

- Minimum Replicas: 2
- Maximum Replicas: 10
- Autoscaling: Future Implementation

---

## 11. Exposure

**Internal Kubernetes Service (ClusterIP)**

### Reason

The Cart Service should not be exposed directly to the internet. Only trusted internal services such as the Frontend and Checkout Service should communicate with it through the Kubernetes network.

---

## 12. Monitoring

Monitor the following metrics:

### Application Metrics

- CPU utilization
- Memory utilization
- Request throughput
- Request latency
- Error rate
- Availability

### Redis Metrics

- Redis connection status
- Redis latency
- Memory utilization
- Connected clients
- Cache hit ratio

---

## 13. Logging

The service should log:

- Cart creation requests
- Add-to-cart operations
- Remove-from-cart operations
- Quantity update operations
- Redis connection failures
- gRPC communication errors
- Startup events
- Health probe results
- Application errors

---

## 14. Security

- Do not hardcode secrets.
- Store Redis credentials securely.
- Restrict external access.
- Use secure service-to-service communication.
- Apply least-privilege access controls.
- Enable centralized logging and auditing.
- Encrypt communication with Redis.

### Future Azure Design

- Azure Key Vault for secret management.
- Azure Managed Identity for authentication.

---

## 15. Recovery Strategy

If a Cart Service pod fails:

- Kubernetes automatically recreates the failed pod.

If an AKS node fails (Future Azure Design):

- AKS schedules the pod onto another healthy node.

If Redis becomes unavailable:

- Shopping cart operations become temporarily unavailable until Redis is restored.

Deployment Strategy:

- Rolling Updates
- Zero-Downtime Deployments

---

## 16. Service Availability Requirements

| Requirement | Target |
|------------|--------|
| Availability | 99.9% |
| Deployment Strategy | Rolling Updates |
| High Availability | Multiple Replicas |
| Recovery Objective (RTO) | Less than 15 Minutes |
| Recovery Point Objective (RPO) | Near Zero (Using Redis Replication) |

---

## 17. Future Improvements

- Implement Redis replication for higher availability.
- Configure Redis persistence for improved durability.
- Support cart expiration policies.
- Add distributed tracing.
- Improve cache monitoring and alerting.
- Implement optimistic concurrency for simultaneous cart updates.
- Introduce AI-based shopping cart recommendations.