resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-clouddesk"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-clouddesk"

  node_provisioning_profile {
    mode               = "Manual"
    default_node_pools = "None"
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "system"
    vm_size    = "Standard_D2s_v5"
    node_count = 1

    os_disk_size_gb = 30
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    environment = "dev"
    project     = "clouddesk"
    managed_by  = "terraform"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}