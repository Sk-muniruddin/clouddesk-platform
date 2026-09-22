resource "azuread_application" "github_actions" {
  display_name = "clouddesk-github-actions"
}

resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
}

resource "azuread_application_federated_identity_credential" "github_actions" {
  application_id = azuread_application.github_actions.id

  display_name = "github-test-cloudedesk"

  description = "GitHub Actions OIDC for test-cloudedesk branch"

  audiences = [
    "api://AzureADTokenExchange"
  ]

  issuer = "https://token.actions.githubusercontent.com"

  subject = "repo:Sk-muniruddin/clouddesk-platform:ref:refs/heads/test-cloudedesk"
}

resource "azurerm_role_assignment" "github_acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.github_actions.object_id
}