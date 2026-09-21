variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-clouddesk-devops"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "acr_name" {
  description = "Globally unique Azure Container Registry name"
  type        = string
  default     = "clouddeskacr"
}
variable "tenant_id" {
  description = "Microsoft Entra tenant ID"
  type        = string
}