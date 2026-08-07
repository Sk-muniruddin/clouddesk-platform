# Virtual Network Design

## Virtual Network

vnet-clouddesk

## Design

One Virtual Network with multiple subnets.

## Subnets

### Application Gateway Subnet

Hosts Azure Application Gateway.

### AKS Subnet

Hosts Azure Kubernetes Service.

### Private Endpoint Subnet

Hosts private endpoints for:

- Azure Key Vault
- Azure Cache for Redis

## Benefits

- Security
- Isolation
- Scalability
- Enterprise networking