# Frontend Service

## 1. Overview

The Frontend service is the customer-facing web application of the Online Boutique. It is the entry point for customers to interact with the platform. The service receives user requests, communicates with backend microservices, and renders responses in the browser.

---

## 2. Business Purpose

The Frontend provides customers with an easy-to-use interface for browsing products, managing their shopping cart, and completing purchases. It brings together data from multiple backend services to deliver a complete shopping experience.

---

## 3. Responsibilities

* Display product catalog
* Display product details
* Display shopping cart
* Display checkout page
* Receive customer requests
* Communicate with backend services
* Render responses to users

---
## 4.Dependencies

Upstream Dependencies

  Services the Frontend calls.

  - Product Catalog
  - Cart
  - Recommendation
  - Currency
  - Checkout

Downstream Consumers

   Services that call Frontend.

    - End Users (Browser)
    - Azure Ingress Controller

## 5. Architecture Position

The Frontend sits at the edge of the application architecture and acts as the entry point for end users. It receives external HTTP/HTTPS requests and communicates with internal backend microservices to process customer actions and display results.

---

## 6. Technology Stack

* Programming Language: Go
* Communication Protocol: HTTP (client requests), gRPC (backend communication)
* Containerization: Docker
* Orchestration: Kubernetes
* Cloud Platform: Azure Kubernetes Service (AKS)

---

## 7. Stateful / Stateless

**Stateless**

### Reason

The Frontend does not permanently store customer or business data. Each request is processed independently by retrieving the required information from backend services. Because no persistent application state is stored locally, multiple Frontend instances can run simultaneously behind a load balancer, enabling horizontal scaling and high availability.

---

## 8. Failure Impact

If the Frontend service becomes unavailable:

* Customers cannot access the Online Boutique.
* Browsing, shopping cart, and checkout become unavailable.
* Backend services may continue running, but users cannot interact with them through the web interface.

---

## 9. Azure Hosting

**Azure Kubernetes Service (AKS)**

### Reason

The Frontend is a containerized microservice that benefits from Kubernetes features such as automatic scaling, rolling updates, self-healing, and high availability.

---

## 10. Scaling Strategy

Horizontal scaling using Kubernetes replicas and the Horizontal Pod Autoscaler (HPA).

Scaling can be based on metrics such as:

* CPU utilization
* Memory utilization
* Request load

---

## 11. Exposure

**Ingress Controller**

The Frontend is exposed externally through an Ingress Controller, which routes HTTP/HTTPS traffic from users to the Frontend service while keeping backend services private.

---

## 12. Monitoring

Key metrics include:

* CPU utilization
* Memory utilization
* Response time (Latency)
* Availability (Uptime)
* Error rate (4xx/5xx responses)
* Request throughput

---

## 13. Security

* Use HTTPS for all client communication.
* Store secrets in Azure Key Vault.
* Do not hardcode secrets in the application.
* Secure communication between services.
* Apply least-privilege access where applicable.

---

## 14. Future Improvements

* Add response caching to improve performance.
* Implement a Content Delivery Network (CDN) for static assets.
* Enhance observability with distributed tracing.
* Improve resilience using retry and circuit breaker patterns.
* Strengthen authentication and authorization if customer accounts are introduced.
