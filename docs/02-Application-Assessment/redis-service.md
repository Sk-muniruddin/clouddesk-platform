# Redis Service Assessment

---

# 1. Overview

Redis is an in-memory data store used by the CloudDesk Commerce Platform to provide high-speed data storage and retrieval for temporary application data. Within the application, Redis is primarily used by the Cart Service to store customer shopping cart information.

Unlike the application microservices, Redis is a stateful infrastructure component responsible for maintaining application data.

---

# 2. Business Purpose

Redis enables fast storage and retrieval of shopping cart information, ensuring customers experience low-latency cart operations while browsing products and completing purchases.

Its in-memory architecture significantly improves application responsiveness compared to traditional databases for temporary session data.

---

# 3. Responsibilities

- Store shopping cart data.
- Retrieve shopping cart data.
- Update shopping cart contents.
- Remove expired shopping carts.
- Support high-speed read and write operations.
- Provide low-latency access for dependent services.

---

# 4. Dependencies

## Upstream Consumers

- Cart Service

## Downstream Dependencies

- None

> **Verified Repository Fact:** Redis stores shopping cart data used by the Cart Service.

---

# 5. Architecture Position

Redis is an internal stateful data store that supports the Cart Service by maintaining shopping cart information outside the application containers.

It is not directly accessed by end users and should never be publicly exposed.

---

# 6. Technology Stack

## Current Implementation

- Technology: Redis
- Deployment: Kubernetes
- Communication Protocol: Redis Protocol (TCP)
- Storage: In-Memory Data Store

## Future Azure Design

- Azure Cache for Redis

---

# 7. Communication Flow

```text
Customer
      │
      ▼
Frontend
      │
      ▼
Cart Service
      │
      ▼
Redis
```

---

# 8. Business Transaction Flow

```text
Customer Adds Product
          │
          ▼
Cart Service Receives Request
          │
          ▼
Store Shopping Cart in Redis
          │
          ▼
Retrieve Cart When Requested
          │
          ▼
Return Shopping Cart
```

---

# 9. Stateful / Stateless

**Stateful Infrastructure Component**

## Reason

Redis permanently maintains application state during runtime by storing customer shopping cart information. Unlike stateless microservices, Redis must preserve data independently of application containers.

Because customer shopping carts are stored in Redis, replacing or restarting the Cart Service does not result in data loss.

---

# 10. Failure Impact

If Redis becomes unavailable:

- Customers lose access to shopping cart data.
- Cart operations fail.
- Checkout cannot retrieve shopping cart information.
- Customers may abandon purchases.
- Revenue generation is impacted.

**Business Impact:** Critical

---

# 11. Hosting Strategy

## Current Implementation

- Kubernetes Deployment

## Future Azure Design

- Azure Cache for Redis

### Reason

Azure Cache for Redis provides:

- Fully Managed Service
- High Availability
- Automatic Failover
- Built-in Monitoring
- Automatic Patching
- Backup and Recovery Options
- Horizontal Scaling

---

# 12. Scaling Strategy

Redis primarily scales vertically.

High availability can also be achieved using replication and clustering.

### Scaling Metrics

- Memory Utilization
- Connected Clients
- Operations Per Second
- Network Throughput
- Cache Hit Ratio

### Initial Capacity Planning (Design Decision)

- High Availability Enabled
- Replication Enabled
- Automatic Failover Enabled

---

# 13. Exposure

**Internal Private Endpoint**

## Reason

Redis should never be exposed directly to the internet.

Only trusted backend services, such as the Cart Service, should communicate with Redis over a private network.

---

# 14. Monitoring

## Infrastructure Metrics

- Memory Utilization
- CPU Utilization
- Connected Clients
- Cache Hit Ratio
- Operations Per Second
- Replication Health
- Network Throughput
- Evicted Keys

## Business Metrics

- Active Shopping Carts
- Cart Read Operations
- Cart Write Operations
- Failed Redis Requests

---

# 15. Logging

Redis should log:

- Connection Events
- Authentication Failures
- Replication Events
- Memory Warnings
- Slow Queries
- Startup Events
- Shutdown Events
- Persistence Events
- Application Errors

---

# 16. Security

## Current Implementation

- Restrict external access.
- Require authentication.
- Encrypt communication where supported.
- Apply least-privilege access controls.
- Enable auditing.

## Future Azure Design

- Azure Private Link
- Azure Key Vault
- Azure Managed Identity
- Azure RBAC
- Private Networking

---

# 17. Recovery Strategy

If Redis becomes unavailable:

- Restore service using high-availability replica.
- Automatically fail over to a healthy node.
- Restore data from persistence if required.

If Azure Cache for Redis fails (Future Azure Design):

- Automatic failover.
- Restore from backup if necessary.

Deployment Strategy:

- High Availability
- Automatic Failover
- Data Replication

---

# 18. Service Availability Requirements

| Requirement | Target |
|------------|--------|
| Availability | 99.9% |
| Deployment Strategy | High Availability |
| Automatic Failover | Enabled |
| Replication | Enabled |
| Recovery Time Objective (RTO) | Less than 15 Minutes |
| Recovery Point Objective (RPO) | Near Zero |

---

# 19. Future Improvements

- Deploy Redis Cluster for horizontal scalability.
- Enable Redis Sentinel for automatic failover.
- Configure persistence policies.
- Improve monitoring using Azure Monitor.
- Implement distributed tracing.
- Introduce intelligent cache eviction strategies.
- Enable AI-based cache performance optimization.