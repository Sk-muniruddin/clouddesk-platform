# Ad Service Assessment

## 1. Overview

The Ad Service is a backend microservice responsible for providing advertisements based on contextual information supplied by other services. It exposes a gRPC interface and returns advertisement information that matches the requested context.

**Verified Repository Fact:** The service is implemented in Java and uses gRPC for communication.

---

## 2. Business Purpose

The Ad Service provides advertisements within the CloudDesk Commerce Platform based on the context of a request.

Its purpose is to:

* Receive advertisement requests.
* Evaluate the supplied context.
* Select applicable advertisements.
* Return advertisement information to the requesting service.

The service operates independently from the main product catalog, cart, payment, and checkout operations.

---

## 3. Responsibilities

The Ad Service is responsible for:

* Receiving advertisement requests through gRPC.
* Processing advertisement context information.
* Selecting applicable advertisements.
* Returning advertisement responses.
* Maintaining its advertisement data in application memory.
* Providing gRPC health-check functionality.
* Starting and managing its gRPC server.
* Gracefully shutting down the service when requested.

**Verified Repository Fact:** The service maintains advertisement data in memory rather than using an external database or Redis instance.

---

## 4. Dependencies

### Upstream Consumers

The actual upstream consumers should be determined from the complete application service-to-service communication assessment.

**Assessment Status:** Service relationships will be finalized after all microservices are inspected.

### Downstream Dependencies

The Ad Service does not currently require:

* Redis
* Relational database
* External database
* Persistent storage
* Azure Cache for Redis

**Verified Repository Fact:** The service contains its advertisement data in application memory.

### Runtime Dependencies

The service uses:

* Java
* Gradle
* gRPC
* Protocol Buffers
* Netty gRPC runtime

---

## 5. Architecture Position

The Ad Service is an internal backend microservice within the CloudDesk Commerce Platform.

It should operate inside the Kubernetes cluster and communicate with other application services through the Kubernetes internal network.

The service should not be directly exposed to the public internet.

Its general architecture position is:

```text
Internal Application Service
          |
          v
     Ad Service
          |
          v
   In-Memory Ad Data
```

---

## 6. Technology Stack

* Programming Language: Java
* Java Version: 21
* Build System: Gradle
* Communication Protocol: gRPC
* Interface Definition: Protocol Buffers
* gRPC Runtime: Netty
* Containerization: Docker
* Orchestration: Kubernetes
* Future Cloud Platform: Azure Kubernetes Service (AKS)

**Verified Repository Fact:** The service uses gRPC and Protocol Buffers and runs on Java 21.

---

## 7. Stateful / Stateless

**Stateless Service**

### Reason

The Ad Service does not maintain persistent application state outside the running process.

Advertisement data is loaded and maintained in application memory.

Therefore, multiple Ad Service instances can operate independently without requiring a shared database or Redis instance.

```text
Ad Service Pod 1 ──┐
                   ├── In-memory advertisement data
Ad Service Pod 2 ──┘
```

**Important Design Consideration:** Because advertisement data is stored in memory, each replica maintains its own copy of the advertisement data.

---

## 8. Failure Impact

If the Ad Service becomes unavailable:

* Advertisement requests cannot be processed.
* Advertisement functionality may be unavailable to dependent services.
* The core shopping workflow can potentially continue if advertisement functionality is not a hard dependency of checkout.

**Business Impact:** Medium

The exact business impact should be confirmed against the application's actual request flow after all service dependencies are assessed.

---

## 9. Hosting Strategy

### Current Application

* Docker container
* Kubernetes
* Internal gRPC communication

### Future Azure Design

* Azure Kubernetes Service (AKS)
* Azure Container Registry (ACR)

The Docker image will be stored in ACR and deployed as a Kubernetes workload in AKS.

### Reason

AKS provides:

* Container orchestration
* Self-healing
* Rolling deployments
* Horizontal scaling
* Service discovery
* Internal networking

ACR provides centralized storage for the Ad Service container image.

---

## 10. Scaling Strategy

The Ad Service can be horizontally scaled using multiple Kubernetes replicas.

Example:

```text
                 Kubernetes Service
                         |
             ┌───────────┼───────────┐
             ▼           ▼           ▼
          Pod 1       Pod 2        Pod 3
        Ad Service   Ad Service   Ad Service
```

### Initial Capacity Planning

**Design Decision:** Initial replica count will be determined during Kubernetes implementation after observing actual resource consumption and application behavior.

HPA may be introduced later based on measured:

* CPU utilization
* Memory utilization
* Request volume
* Application performance

We will not claim a fixed minimum/maximum replica count until it has been deliberately selected and tested.

---

## 11. Exposure

**Internal Kubernetes Service — ClusterIP**

The Ad Service should not be exposed directly to the public internet.

### Reason

The service is a backend microservice and is intended to be accessed by other services inside the application platform.

The expected architecture is:

```text
External User
     |
     v
  Frontend
     |
     v
Internal Kubernetes Network
     |
     v
 Ad Service
```

No public Ingress endpoint is required for the Ad Service.

---

## 12. Monitoring

The Ad Service should be monitored for:

### Application Metrics

* Request count
* Request latency
* Error rate
* gRPC request failures
* Service availability
* CPU utilization
* Memory utilization
* Pod restarts

### Kubernetes Metrics

* Pod status
* Container restart count
* CPU consumption
* Memory consumption
* Deployment availability
* Replica availability

### Health Monitoring

The service provides a gRPC health service that can be used for Kubernetes health checks.

**Verified Repository Fact:** A gRPC health-check implementation exists in the service.

---

## 13. Logging

The service should provide logs for:

* Service startup
* Service shutdown
* gRPC request failures
* Application errors
* Unexpected exceptions
* Configuration/startup errors
* Dependency or runtime failures where applicable

Kubernetes will collect container logs, which can later be integrated with Azure Monitor and Log Analytics.

We should not claim detailed business-operation logging unless it is actually implemented in the source code.

---

## 14. Security

The Ad Service should follow these security principles:

* Do not hardcode credentials or secrets.
* Do not expose the service directly to the internet.
* Restrict access through Kubernetes networking.
* Apply least-privilege permissions.
* Use secure communication where required by the final platform architecture.
* Keep container privileges to the minimum required.
* Avoid running the container as root where the application permits it.

### Future Azure Design

Azure-specific security controls will be determined during the Azure Architecture Assessment.

Potential controls may include:

* Managed Identity
* Azure Key Vault
* Network security controls
* Azure Monitor and centralized logging

**Important:** Key Vault is not required by the Ad Service simply because it is an Azure best practice. It will only be introduced if the final architecture identifies secrets or credentials that require centralized secret management.

---

## 15. Recovery Strategy

If an Ad Service pod fails:

* Kubernetes should detect the failed workload.
* Kubernetes should recreate the pod according to the Deployment configuration.

If an AKS node fails:

* Kubernetes can schedule the workload onto another available node, provided sufficient cluster capacity exists.

Because the service is stateless, recovery does not require restoring persistent service state.

### Deployment Strategy

**Design Decision:**

* Kubernetes Deployment
* Rolling Updates
* Controlled rollout
* Rollback capability

The exact availability configuration will be determined during Kubernetes implementation.

---

## 16. Service Availability Requirements

The following are **design targets**, not currently verified application guarantees.

| Requirement                    | Target                          |
| ------------------------------ | ------------------------------- |
| Availability                   | To be determined                |
| Deployment Strategy            | Rolling Updates                 |
| High Availability              | Multiple Replicas               |
| Recovery Objective (RTO)       | To be determined                |
| Recovery Point Objective (RPO) | Not applicable to service state |

### Reason

The Ad Service does not maintain persistent state in an external datastore. Therefore, traditional data-loss RPO is not applicable to the service's in-memory advertisement data.

If a pod is restarted, its in-memory data will be recreated when the application starts.

---

## 17. Future Improvements

Potential improvements identified during the assessment include:

* Add production-grade application metrics.
* Add distributed tracing.
* Improve structured logging.
* Configure Kubernetes readiness and liveness probes using the gRPC health service.
* Define resource requests and limits.
* Evaluate HPA using actual workload measurements.
* Run the container as a non-root user where supported.
* Perform container image security scanning.
* Optimize the Docker image.
* Introduce centralized monitoring through Azure Monitor.
* Evaluate whether advertisement data should eventually be externalized if dynamic advertisement management becomes a requirement.
* Add automated tests to the CI/CD pipeline.
* Implement automated container image vulnerability scanning.

### Assessment Summary

**Current Status:**

* Microservice: **KEEP**
* Java implementation: **KEEP**
* gRPC communication: **KEEP**
* In-memory advertisement data: **KEEP**
* Redis dependency: **REMOVE / NOT REQUIRED**
* Database dependency: **NOT REQUIRED**
* Public exposure: **REMOVE / NOT REQUIRED**
* Kubernetes Deployment: **ADD during implementation**
* Kubernetes ClusterIP Service: **ADD during implementation**
* gRPC health probes: **ADD during implementation**
* HPA: **DEFER until workload testing**
* Azure Cache for Redis: **REMOVE for this service**
* Key Vault: **DEFER until Azure architecture assessment**
* Azure Monitor: **ADD at platform implementation stage**
