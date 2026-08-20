# Load Generator Service Assessment

## 1. Overview

The Load Generator is a testing and performance-load component of the CloudDesk Commerce Platform. It uses Locust to simulate multiple users interacting with the Frontend Service.

The Load Generator generates realistic user activity such as:

* Opening the homepage.
* Changing currency.
* Browsing products.
* Viewing the shopping cart.
* Adding products to the cart.
* Emptying the cart.
* Performing checkout operations.

**Verified Repository Fact:** The service uses Locust with `FastHttpUser` to generate HTTP traffic against the configured Frontend Service.

---

## 2. Business Purpose

The Load Generator is not a customer-facing business microservice.

Its purpose is to simulate realistic user traffic so that the platform can be tested under controlled load.

It helps validate:

* Application performance.
* Service scalability.
* Kubernetes autoscaling.
* Application availability.
* Service-to-service behavior under load.
* Response times.
* Failure behavior.
* Monitoring and observability.

The Load Generator is therefore a **testing/support component** rather than a core commerce service.

---

## 3. Responsibilities

The Load Generator is responsible for:

* Generating HTTP traffic against the Frontend Service.
* Simulating multiple concurrent users.
* Simulating common e-commerce user journeys.
* Browsing products.
* Changing currencies.
* Adding products to carts.
* Viewing carts.
* Executing checkout requests.
* Generating randomized test data.
* Controlling simulated user count.
* Controlling user spawn rate.

### Supported User Operations

The current Locust workload includes:

* Homepage access.
* Currency selection.
* Product browsing.
* Cart access.
* Add-to-cart operations.
* Empty-cart operations.
* Checkout operations.

**Verified Repository Fact:** The current task distribution gives different weights to the simulated operations, with product browsing occurring more frequently than checkout.

---

## 4. Dependencies

### Upstream Consumers

The Load Generator is not normally called by another application microservice.

It is started by the deployment/operator as a testing workload.

### Downstream Dependencies

The Load Generator depends on:

* Frontend Service

The Frontend address is supplied through the `FRONTEND_ADDR` environment variable.

### Runtime Dependencies

The service uses:

* Python
* Locust
* Faker
* Fast HTTP client functionality provided by Locust
* Python runtime libraries

**Verified Repository Fact:** `requirements.in` specifies:

* `locust==2.43.0`
* `faker==40.1.0`

---

## 5. Architecture Position

The Load Generator is positioned as an **internal testing workload** within the CloudDesk Commerce Platform.

It should not be considered part of the core customer request path.

The intended relationship is:

```text
Load Generator
       |
       | HTTP traffic
       v
   Frontend Service
       |
       v
Commerce Microservices
```

The Load Generator generates traffic toward the Frontend and allows the complete application workflow to be exercised.

---

## 6. Technology Stack

* Programming Language: Python
* Python Runtime: Python 3.14.6 Alpine container image
* Load Testing Framework: Locust 2.43.0
* Test Data Generation: Faker 40.1.0
* HTTP Load Generation: Locust FastHttpUser
* Containerization: Docker
* Orchestration: Kubernetes
* Future Cloud Platform: Azure Kubernetes Service (AKS)

**Verified Repository Fact:** The Dockerfile uses the pinned Python 3.14.6 Alpine image.

---

## 7. Stateful / Stateless

**Stateless Workload**

### Reason

The Load Generator does not maintain persistent application data.

The workload definition is stored in `locustfile.py`, while generated user information and test values are created dynamically during execution.

The workload can therefore be recreated or restarted without requiring persistent application state.

```text
Load Generator Pod
       |
       ├── Locust workload
       ├── Generated test data
       └── HTTP traffic
```

No database, Redis, or persistent volume is required by the current implementation.

---

## 8. Failure Impact

If the Load Generator becomes unavailable:

* Automated traffic generation stops.
* Performance testing cannot continue.
* Autoscaling tests may no longer receive sufficient traffic.
* Load-based validation cannot be performed.

However:

**Core customer-facing commerce functionality is not directly affected.**

The Load Generator is therefore **non-critical to production application availability**.

**Business Impact:** Low for production; potentially High during performance/load-testing activities.

---

## 9. Hosting Strategy

### Current Application

* Docker container
* Locust
* Python
* Internal access to Frontend Service

### Future Azure Design

* Azure Kubernetes Service (AKS)
* Azure Container Registry (ACR)

The Load Generator container image can be stored in ACR and executed as a Kubernetes workload in AKS.

### Reason

Running the Load Generator inside the same Kubernetes environment allows the project to generate realistic internal application traffic and observe Kubernetes behavior under load.

It is particularly useful for testing:

* HPA.
* Pod scaling.
* Application performance.
* Service availability.
* Monitoring.
* Resource utilization.

### Production Consideration

The Load Generator should **not automatically run continuously in a production environment**.

It should normally be started intentionally for testing or performance-validation activities.

---

## 10. Scaling Strategy

The Load Generator does not require application-style horizontal scaling by default.

Instead, the load generated by the service is controlled through Locust parameters.

### Current Configuration

The Dockerfile starts Locust with:

```text
FRONTEND_ADDR
USERS
RATE
```

Default values currently defined by the container command include:

* Users: `10`
* Spawn rate: `1`

The exact values can be overridden through environment variables.

### Scaling Approach

For larger performance tests, the load-generation capacity can be increased by:

* Increasing the number of simulated users.
* Increasing the user spawn rate.
* Running additional load-generator workers where required.

**Design Decision:** HPA should not automatically be applied to the Load Generator without a specific testing requirement. The purpose of this component is to generate controlled load, not to scale like a customer-facing microservice.

---

## 11. Exposure

**No public application exposure is required for the Load Generator.**

The Load Generator should run internally and communicate with the Frontend Service through the Kubernetes network.

```text
Load Generator
      |
      | HTTP
      v
Frontend Service
```

The Locust web UI is not required for the current headless implementation.

**Verified Repository Fact:** The Docker entrypoint runs Locust in `--headless` mode.

Therefore:

* Public Ingress: **Not required**
* Public LoadBalancer: **Not required**
* External endpoint: **Not required**

---

## 12. Monitoring

The Load Generator should be monitored during performance testing.

### Load Generator Metrics

Monitor:

* Number of simulated users.
* Request rate.
* Request failures.
* Request response time.
* Load-generator CPU utilization.
* Load-generator memory utilization.
* Container restarts.

### Application Metrics

The more important monitoring target is the application receiving the generated traffic.

Monitor:

* Frontend response time.
* Frontend error rate.
* Backend service latency.
* Service availability.
* Pod CPU utilization.
* Pod memory utilization.
* HPA behavior.
* Pod scaling events.

### Kubernetes Monitoring

Monitor:

* Pod status.
* Container restarts.
* Resource consumption.
* Deployment status.
* Kubernetes events.

The Load Generator should therefore be used as a **testing mechanism for validating the monitoring and scaling behavior of the entire platform**.

---

## 13. Logging

The Load Generator should provide logs for:

* Startup.
* Locust execution.
* Configuration values used for the test.
* Request failures.
* Connection failures.
* Unexpected runtime errors.
* Test completion or termination.

Because the current implementation runs Locust in headless mode, Locust output is available through the container logs.

Kubernetes can collect these logs and the final Azure monitoring architecture can centralize them through Azure Monitor and Log Analytics where appropriate.

---

## 14. Security

The Load Generator should follow these security principles:

* Do not hardcode credentials.
* Do not store real customer information.
* Do not use real payment credentials.
* Use synthetic test data.
* Keep the workload internal to the Kubernetes cluster.
* Do not expose the Locust workload unnecessarily.
* Restrict network access to the application endpoints required for testing.

### Test Data

The current implementation uses Faker to generate synthetic information such as:

* Email addresses.
* Street addresses.
* ZIP codes.
* Cities.
* States.
* Countries.
* Credit-card test values.

**Important:** These values are generated for testing and must not be treated as real customer payment information.

### Azure Security

No Azure Key Vault dependency is currently required by the Load Generator itself.

If future testing requires credentials or other sensitive configuration, the appropriate secret-management solution will be evaluated during the Azure Architecture Assessment.

---

## 15. Recovery Strategy

The Load Generator does not require persistent state recovery.

If the Load Generator container fails:

* Kubernetes can restart the workload if configured as a Deployment or Job.
* The load test can be restarted.
* No customer application data needs to be recovered.

### Recommended Kubernetes Workload

The exact Kubernetes workload type should depend on how we operate the performance tests.

For continuous controlled testing:

* Kubernetes Deployment may be appropriate.

For a defined test execution:

* Kubernetes Job may be more appropriate.

**Design Decision:** We will determine the final workload type during Kubernetes implementation based on the desired testing workflow.

---

## 16. Service Availability Requirements

The Load Generator does not require the same availability target as customer-facing microservices.

| Requirement             | Target                                |
| ----------------------- | ------------------------------------- |
| Production Availability | Not applicable                        |
| Test Availability       | Required during active test execution |
| Deployment Strategy     | Recreate / controlled deployment      |
| High Availability       | Not required by default               |
| RTO                     | Not critical                          |
| RPO                     | Not applicable                        |

### Reason

The Load Generator does not own customer or business data.

Its state can be recreated by starting another instance and rerunning the test.

---

## 17. Future Improvements

Potential improvements identified during the assessment include:

* Create separate workload profiles for different test scenarios.
* Add configurable test duration.
* Add configurable user behavior weights.
* Add configurable target frontend address.
* Add Kubernetes Job-based test execution.
* Support distributed Locust workers for larger load tests.
* Export performance-test results for analysis.
* Integrate load testing into controlled CI/CD environments.
* Add resource requests and limits.
* Add container image vulnerability scanning.
* Run the container as a non-root user where supported.
* Add centralized logging and monitoring.
* Create repeatable baseline performance tests.
* Establish performance thresholds for latency and error rates.

### Assessment Summary

**Current Status:**

* Load Generator component: **KEEP**
* Python implementation: **KEEP**
* Locust: **KEEP**
* Faker: **KEEP**
* Frontend dependency: **KEEP**
* Redis dependency: **NOT REQUIRED**
* Database dependency: **NOT REQUIRED**
* Persistent storage: **NOT REQUIRED**
* Public Ingress: **REMOVE / NOT REQUIRED**
* Public LoadBalancer: **REMOVE / NOT REQUIRED**
* ACR: **ADD during Azure implementation**
* AKS workload: **ADD during Kubernetes implementation**
* Kubernetes Service: **NOT REQUIRED unless a specific internal service-discovery requirement emerges**
* HPA: **DEFER / NOT REQUIRED by default**
* Key Vault: **NOT REQUIRED unless future test credentials/secrets are introduced**
* Azure Monitor: **ADD at platform monitoring stage**
* Distributed load generation: **DEFER until larger-scale testing is required**

### Final Classification

**The Load Generator is a supporting performance-testing component, not a core commerce microservice.**

It should remain in the application repository and be documented in `02-Application-Architecture`, but its operational treatment should be different from services such as Cart, Checkout, Payment, and Product Catalog.
