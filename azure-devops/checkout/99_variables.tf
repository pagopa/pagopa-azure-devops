locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "checkout"

  # Service connections/ End points
  srv_endpoint_github_ro = "io-azure-devops-github-ro"
  srv_endpoint_github_rw = "io-azure-devops-github-rw"
  srv_endpoint_github_pr = "io-azure-devops-github-pr"

  # 🔐 KV
  dev_key_vault_azdo_name  = "${local.prefix}-d-azdo-weu-kv"
  uat_key_vault_azdo_name  = "${local.prefix}-u-azdo-weu-kv"
  prod_key_vault_azdo_name = "${local.prefix}-p-azdo-weu-kv"

  dev_key_vault_resource_group  = "${local.prefix}-d-sec-rg"
  uat_key_vault_resource_group  = "${local.prefix}-u-sec-rg"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  # ☁️ VNET
  dev_vnet_rg  = "${local.prefix}-d-vnet-rg"
  uat_vnet_rg  = "${local.prefix}-u-vnet-rg"
  prod_vnet_rg = "${local.prefix}-p-vnet-rg"

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
