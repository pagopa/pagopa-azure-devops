locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "qa"

  dev_subscription_name  = "dev-pagopa"
  uat_subscription_name  = "uat-pagopa"
  prod_subscription_name = "prod-pagopa"

  dev_subscription_id  = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  uat_subscription_id  = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  prod_subscription_id = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id

  # KV azdo (hosts the GitHub PAT/email/username used by the pipelines)
  prod_key_vault_azdo_name      = "${local.prefix}-p-azdo-weu-kv"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  # KV UAT (hosts the domain-level GitHub PAT for all QA service connections)
  uat_qa_github_kv_name = "${local.prefix}-u-itn-qa-kv"
  uat_qa_github_kv_rg   = "${local.prefix}-u-itn-qa-sec-rg"

  # Name of the dedicated GitHub service connection created by this domain state
  qa_github_connection_name = "qa-azure-devops-github"

  # VNET
  # Dns Zone RG:
  dev_internal_dns_zone = "pagopa-d-vnet-rg"

  ### 🔑 Key Vault
  dev_kv_domain_name            = "${local.prefix}-d-itn-${local.domain}-kv"
  dev_kv_domain_resource_group  = "${local.prefix}-d-itn-${local.domain}-sec-rg"
  uat_kv_domain_name            = "${local.prefix}-u-itn-${local.domain}-kv"
  uat_kv_domain_resource_group  = "${local.prefix}-u-itn-${local.domain}-sec-rg"
  prod_kv_domain_name           = "${local.prefix}-p-itn-${local.domain}-kv"
  prod_kv_domain_resource_group = "${local.prefix}-p-itn-${local.domain}-sec-rg"

  ### 🔑 Identity
  dev_identity_rg_name  = "${local.prefix}-d-identity-rg"
  uat_identity_rg_name  = "${local.prefix}-u-identity-rg"
  prod_identity_rg_name = "${local.prefix}-p-identity-rg"

  srv_endpoint_name_aks_dev  = "${local.prefix}-${local.domain}-itn-dev-aks"
  srv_endpoint_name_aks_uat  = "${local.prefix}-${local.domain}-itn-uat-aks"
  srv_endpoint_name_aks_prod = "${local.prefix}-${local.domain}-itn-prod-aks"

  tlscert_repository = {
    organization   = "pagopa"
    name           = "le-azure-acme-tiny"
    branch_name    = "refs/heads/master"
    pipelines_path = "."
  }

}

variable "dev_subscription_name" {
  type        = string
  description = "DEV Subscription name"
}

variable "uat_subscription_name" {
  type        = string
  description = "UAT Subscription name"
}

variable "prod_subscription_name" {
  type        = string
  description = "PROD Subscription name"
}

variable "project_name" {
  type        = string
  description = "Project name (e.g. pagoPA platform)"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "pipeline_environments" {
  type        = list(any)
  description = "List of environments pipeline to create"
}

#
# AZURERM
#
variable "service_connection_dev_azurerm_name" {
  type        = string
  description = "Azurerm service connection DEV name"
}

variable "service_connection_uat_azurerm_name" {
  type        = string
  description = "Azurerm service connection UAT name"
}

variable "service_connection_prod_azurerm_name" {
  type        = string
  description = "Azurerm service connection PROD name"
}

#
# ACR
#
variable "service_connection_dev_acr_name" {
  type        = string
  description = "ACR service connection DEV name"
}

variable "service_connection_uat_acr_name" {
  type        = string
  description = "ACR service connection UAT name"
}

variable "service_connection_prod_acr_name" {
  type        = string
  description = "ACR service connection PROD name"
}

#
# ACR workload identity
#
variable "acr_weu_service_connection_workload_identity_dev" {
  type        = string
  description = "The service connection ID for the WEU DEV workload identity in Azure Container Registry"
  default     = ""
}

variable "acr_weu_service_connection_workload_identity_uat" {
  type        = string
  description = "The service connection ID for the WEU UAT workload identity in Azure Container Registry"
  default     = ""
}

variable "acr_weu_service_connection_workload_identity_prod" {
  type        = string
  description = "The service connection ID for the WEU PROD workload identity in Azure Container Registry"
  default     = ""
}

variable "acr_ita_service_connection_workload_identity_dev" {
  type        = string
  description = "The service connection ID for the ITA DEV workload identity in Azure Container Registry"
  default     = ""
}

variable "acr_ita_service_connection_workload_identity_uat" {
  type        = string
  description = "The service connection ID for the ITA UAT workload identity in Azure Container Registry"
  default     = ""
}

variable "acr_ita_service_connection_workload_identity_prod" {
  type        = string
  description = "The service connection ID for the ITA PROD workload identity in Azure Container Registry"
  default     = ""
}
