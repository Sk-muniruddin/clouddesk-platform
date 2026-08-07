# Azure Kubernetes Service Architecture

## Purpose

Runs all application microservices.

## Hosted Services

- Frontend
- Product Catalog
- Cart
- Checkout
- Payment
- Shipping
- Currency
- Email
- Recommendation

## Availability

- Multiple replicas
- Availability Zones
- Horizontal Pod Autoscaler

## Health

- Liveness Probe
- Readiness Probe

## Internal Communication

ClusterIP Services

## Ingress

NGINX Ingress Controller