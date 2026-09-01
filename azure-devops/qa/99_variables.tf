locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "qa"

  dev_subscription_name  = "dev-pagopa"
  uat_subscription_name  = "uat-pagopa"
  prod_subscription_name = "prod-pagopa"

  # KV azdo (hosts the GitHub PAT/email/username used by the pipelines)
  prod_key_vault_azdo_name      = "${local.prefix}-p-azdo-weu-kv"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  # KV UAT (hosts the domain-level GitHub PAT for all QA service connections)
  uat_qa_github_kv_name = "${local.prefix}-u-itn-qa-kv"
  uat_qa_github_kv_rg   = "${local.prefix}-u-itn-qa-sec-rg"

  # Name of the dedicated GitHub service connection created by this domain state
  qa_github_connection_name = "qa-azure-devops-github"
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
