locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "centralhub"

  dev_subscription_name  = "dev-pagopa"
  uat_subscription_name  = "uat-pagopa"
  prod_subscription_name = "prod-pagopa"

  location_short = "itn"

  # 🔐 KV azdo (shared)
  prod_key_vault_azdo_name      = "${local.prefix}-p-azdo-weu-kv"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  # 🔐 KV DOMAIN
  dev_centralhub_key_vault_name  = "${local.prefix}-d-${local.location_short}-portalpa-kv"
  prod_centralhub_key_vault_name = "${local.prefix}-p-${local.location_short}-portalpa-kv"

  dev_centralhub_key_vault_resource_group  = "${local.prefix}-d-${local.location_short}-portalpa-sec-rg"
  prod_centralhub_key_vault_resource_group = "${local.prefix}-p-${local.location_short}-portalpa-sec-rg"

  # KV PROD (hosts the domain-level GitHub PAT for Central Hub service connection)
  prod_centralhub_github_kv_name = local.prod_centralhub_key_vault_name
  prod_centralhub_github_kv_rg   = local.prod_centralhub_key_vault_resource_group

  # Dedicated service connection name created by this domain state
  centralhub_github_connection_name = "centralhub-azure-devops-github"
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
# AKS (WEU)
#
variable "aks_dev_platform_name" {
  type        = string
  description = "AKS DEV platform name"
  default     = ""
}

variable "aks_uat_platform_name" {
  type        = string
  description = "AKS UAT platform name"
  default     = ""
}

variable "aks_prod_platform_name" {
  type        = string
  description = "AKS PROD platform name"
  default     = ""
}

#
# AKS (ITN)
#
variable "aks_itn_dev_platform_name" {
  type        = string
  description = "AKS ITN DEV platform name"
  default     = ""
}

variable "aks_itn_uat_platform_name" {
  type        = string
  description = "AKS ITN UAT platform name"
  default     = ""
}

variable "aks_itn_prod_platform_name" {
  type        = string
  description = "AKS ITN PROD platform name"
  default     = ""
}

#
# ACR workload identity
#
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

#
# ACR workload identity (WEU)
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
