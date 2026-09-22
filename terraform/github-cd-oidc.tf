resource "azuread_application" "github_actions_cd" {
  display_name = "clouddesk-github-actions-cd"
}

resource "azuread_service_principal" "github_actions_cd" {
  client_id = azuread_application.github_actions_cd.client_id
}

resource "azuread_application_federated_identity_credential" "github_actions_cd" {
  application_id = azuread_application.github_actions_cd.id

  display_name = "github-test-cloudedesk-cd"

  description = "GitHub Actions OIDC for AKS CD on test-cloudedesk"

  audiences = [
    "api://AzureADTokenExchange"
  ]

  issuer = "https://token.actions.githubusercontent.com"

  subject = "repo:Sk-muniruddin/clouddesk-platform:ref:refs/heads/test-cloudedesk"
}

resource "azurerm_role_assignment" "github_aks_cluster_admin" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azuread_service_principal.github_actions_cd.object_id
}

output "github_actions_cd_client_id" {
  description = "Client ID for GitHub Actions CD"
  value       = azuread_application.github_actions_cd.client_id
}