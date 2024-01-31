locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "externals"

  #tfsec:ignore:general-secrets-no-plaintext-exposure
  #tfsec:ignore:GEN002
  tlscert_renew_token        = "v3"

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

  dev_key_vault_name  = "${local.prefix}-d-kv"
  uat_key_vault_name  = "${local.prefix}-u-kv"
  prod_key_vault_name = "${local.prefix}-p-kv"

  dev_key_vault_resource_group  = "${local.prefix}-d-sec-rg"
  uat_key_vault_resource_group  = "${local.prefix}-u-sec-rg"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  # ☁️ VNET
  dev_vnet_rg  = "${local.prefix}-d-vnet-rg"
  uat_vnet_rg  = "${local.prefix}-u-vnet-rg"
  prod_vnet_rg = "${local.prefix}-p-vnet-rg"

  srv_endpoint_github_ro = "io-azure-devops-github-ro"
  srv_endpoint_github_rw = "io-azure-devops-github-rw"
  srv_endpoint_github_pr = "io-azure-devops-github-pr"

}

variable "location" {
  type = string
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

variable "project_name_prefix" {
  type        = string
  description = "Project name prefix (e.g. userregistry)"
}

variable "pipeline_environments" {
  type        = list(any)
  description = "List of environments pipeline to create"
}

variable "project_name" {
  type        = string
  description = "Project name (e.g. pagoPA platform)"
}
