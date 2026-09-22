output "aks_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_resource_group" {
  description = "Resource group containing AKS"
  value       = azurerm_kubernetes_cluster.aks.resource_group_name
}

output "aks_fqdn" {
  description = "AKS API server FQDN"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}