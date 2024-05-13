locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "pay-wallet"

  location            = "italynorth"
  location_westeurope = "westeurope"
  location_short      = "itn"

  dev_subscription_name  = "dev-pagopa"
  uat_subscription_name  = "uat-pagopa"
  prod_subscription_name = "prod-pagopa"

  dev_identity_rg_name  = "${local.prefix}-d-identity-rg"
  uat_identity_rg_name  = "${local.prefix}-u-identity-rg"
  prod_identity_rg_name = "${local.prefix}-p-identity-rg"

  # 🔐 KV
  dev_key_vault_azdo_name  = "${local.prefix}-d-azdo-weu-kv"
  uat_key_vault_azdo_name  = "${local.prefix}-u-azdo-weu-kv"
  prod_key_vault_azdo_name = "${local.prefix}-p-azdo-weu-kv"

  dev_wallet_key_vault_name  = "${local.prefix}-d-${local.location_short}-${local.domain}-kv"
  uat_wallet_key_vault_name  = "${local.prefix}-u-${local.location_short}-${local.domain}-kv"
  prod_wallet_key_vault_name = "${local.prefix}-p-${local.location_short}-${local.domain}-kv"

  dev_key_vault_resource_group  = "${local.prefix}-d-sec-rg"
  uat_key_vault_resource_group  = "${local.prefix}-u-sec-rg"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  dev_wallet_key_vault_resource_group  = "${local.prefix}-d-${local.location_short}-${local.domain}-sec-rg"
  uat_wallet_key_vault_resource_group  = "${local.prefix}-u-${local.location_short}-${local.domain}-sec-rg"
  prod_wallet_key_vault_resource_group = "${local.prefix}-p-${local.location_short}-${local.domain}-sec-rg"

  # ☁️ VNET
  dev_vnet_rg  = "${local.prefix}-d-vnet-rg"
  uat_vnet_rg  = "${local.prefix}-u-vnet-rg"
  prod_vnet_rg = "${local.prefix}-p-vnet-rg"

  # 📦 ACR DEV FOR AKS
  aks_cr_rg_name_dev           = "${local.prefix}-d-${local.location_short}-acr-rg"
  aks_cr_name_dev              = "${local.prefix}d${local.location_short}coreacr"

  # 📦 ACR UAT FOR AKS
  aks_cr_rg_name_uat           = "${local.prefix}-u-${local.location_short}-acr-rg"
  aks_cr_name_uat              = "${local.prefix}u${local.location_short}coreacr"

  # 📦 ACR PROD FOR AKS
  aks_cr_rg_name_prod           = "${local.prefix}-p-${local.location_short}-acr-rg"
  aks_cr_name_prod              = "${local.prefix}p${local.location_short}coreacr"

  srv_endpoint_name_aks_dev  = "${local.prefix}-${local.domain}-${local.location_short}-dev-aks"
  srv_endpoint_name_aks_uat  = "${local.prefix}-${local.domain}-${local.location_short}-uat-aks"
  srv_endpoint_name_aks_prod = "${local.prefix}-${local.domain}-${local.location_short}-prod-aks"

  #tfsec:ignore:general-secrets-no-plaintext-exposure
  #tfsec:ignore:GEN002
  tlscert_renew_token = "v1"

  # TODO azure devops terraform provider does not support SonarCloud service endpoint
  azuredevops_serviceendpoint_sonarcloud_id = "9182be64-d387-465d-9acc-e79e802910c8"
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

variable "pipeline_environments" {
  type        = list(any)
  description = "List of environments pipeline to create"
}

variable "location" {
  type = string
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
