locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"

  dev_subscription_name  = "dev-pagopa"
  uat_subscription_name  = "uat-pagopa"
  prod_subscription_name = "prod-pagopa"

  dev_key_vault_name  = "${local.prefix}-d-kv"
  uat_key_vault_name  = "${local.prefix}-u-kv"
  prod_key_vault_name = "${local.prefix}-p-kv"

  dev_identity_rg_name  = "${local.prefix}-d-identity-rg"
  uat_identity_rg_name  = "${local.prefix}-u-identity-rg"
  prod_identity_rg_name = "${local.prefix}-p-identity-rg"

  # Service connections/ End points
  srv_endpoint_github_ro = "io-azure-devops-github-ro"
  srv_endpoint_github_rw = "io-azure-devops-github-rw"
  srv_endpoint_github_pr = "io-azure-devops-github-pr"

  # 🔐 KV AZDO
  dev_key_vault_azdo_name  = "${local.prefix}-d-azdo-weu-kv"
  uat_key_vault_azdo_name  = "${local.prefix}-u-azdo-weu-kv"
  prod_key_vault_azdo_name = "${local.prefix}-p-azdo-weu-kv"

  dev_key_vault_resource_group  = "${local.prefix}-d-sec-rg"
  uat_key_vault_resource_group  = "${local.prefix}-u-sec-rg"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  # 🔐 KV Domain
  dev_shared_key_vault_resource_group  = "${local.prefix}-d-shared-sec-rg"
  uat_shared_key_vault_resource_group  = "${local.prefix}-u-shared-sec-rg"
  prod_shared_key_vault_resource_group = "${local.prefix}-p-shared-sec-rg"

  dev_shared_key_vault_name  = "${local.prefix}-d-shared-kv"
  uat_shared_key_vault_name  = "${local.prefix}-u-shared-kv"
  prod_shared_key_vault_name = "${local.prefix}-p-shared-kv"

  dev_afm_key_vault_resource_group  = "${local.prefix}-d-afm-sec-rg"
  uat_afm_key_vault_resource_group  = "${local.prefix}-u-afm-sec-rg"
  prod_afm_key_vault_resource_group = "${local.prefix}-p-afm-sec-rg"

  dev_afm_key_vault_name  = "${local.prefix}-d-afm-kv"
  uat_afm_key_vault_name  = "${local.prefix}-u-afm-kv"
  prod_afm_key_vault_name = "${local.prefix}-p-afm-kv"

  dev_bizevents_key_vault_resource_group  = "${local.prefix}-d-bizevents-sec-rg"
  uat_bizevents_key_vault_resource_group  = "${local.prefix}-u-bizevents-sec-rg"
  prod_bizevents_key_vault_resource_group = "${local.prefix}-p-bizevents-sec-rg"

  dev_bizevents_key_vault_name  = "${local.prefix}-d-bizevents-kv"
  uat_bizevents_key_vault_name  = "${local.prefix}-u-bizevents-kv"
  prod_bizevents_key_vault_name = "${local.prefix}-p-bizevents-kv"

  dev_gps_key_vault_resource_group  = "${local.prefix}-d-gps-sec-rg"
  uat_gps_key_vault_resource_group  = "${local.prefix}-u-gps-sec-rg"
  prod_gps_key_vault_resource_group = "${local.prefix}-p-gps-sec-rg"

  dev_gps_key_vault_name  = "${local.prefix}-d-gps-kv"
  uat_gps_key_vault_name  = "${local.prefix}-u-gps-kv"
  prod_gps_key_vault_name = "${local.prefix}-p-gps-kv"

### ECOMMERCE
  dev_ecommerce_key_vault_resource_group  = "${local.prefix}-d-ecommerce-sec-rg"
  uat_ecommerce_key_vault_resource_group  = "${local.prefix}-u-ecommerce-sec-rg"
  prod_ecommerce_key_vault_resource_group = "${local.prefix}-p-ecommerce-sec-rg"

  dev_ecommerce_key_vault_name  = "${local.prefix}-d-ecommerce-kv"
  uat_ecommerce_key_vault_name  = "${local.prefix}-u-ecommerce-kv"
  prod_ecommerce_key_vault_name = "${local.prefix}-p-ecommerce-kv"

### ELK
  dev_elk_key_vault_name  = "${local.prefix}-d-elk-kv"
  uat_elk_key_vault_name  = "${local.prefix}-u-elk-kv"
  prod_elk_key_vault_name = "${local.prefix}-p-elk-kv"

  dev_elk_key_vault_resource_group  = "${local.prefix}-d-elk-sec-rg"
  uat_elk_key_vault_resource_group  = "${local.prefix}-u-elk-sec-rg"
  prod_elk_key_vault_resource_group = "${local.prefix}-p-elk-sec-rg"

### SELFCARE
  dev_selfcare_key_vault_resource_group  = "${local.prefix}-d-selfcare-sec-rg"
  uat_selfcare_key_vault_resource_group  = "${local.prefix}-u-selfcare-sec-rg"
  prod_selfcare_key_vault_resource_group = "${local.prefix}-p-selfcare-sec-rg"

  dev_selfcare_key_vault_name  = "${local.prefix}-d-selfcare-kv"
  uat_selfcare_key_vault_name  = "${local.prefix}-u-selfcare-kv"
  prod_selfcare_key_vault_name = "${local.prefix}-p-selfcare-kv"

  dev_nodo_key_vault_resource_group  = "${local.prefix}-d-nodo-sec-rg"
  uat_nodo_key_vault_resource_group  = "${local.prefix}-u-nodo-sec-rg"
  prod_nodo_key_vault_resource_group = "${local.prefix}-p-nodo-sec-rg"

  dev_nodo_key_vault_name  = "${local.prefix}-d-nodo-kv"
  uat_nodo_key_vault_name  = "${local.prefix}-u-nodo-kv"
  prod_nodo_key_vault_name = "${local.prefix}-p-nodo-kv"

  dev_wallet_key_vault_resource_group  = "${local.prefix}-d-wallet-sec-rg"
  uat_wallet_key_vault_resource_group  = "${local.prefix}-u-wallet-sec-rg"
  prod_wallet_key_vault_resource_group = "${local.prefix}-p-wallet-sec-rg"

  dev_wallet_key_vault_name  = "${local.prefix}-d-wallet-kv"
  uat_wallet_key_vault_name  = "${local.prefix}-u-wallet-kv"
  prod_wallet_key_vault_name = "${local.prefix}-p-wallet-kv"

  dev_fdr_key_vault_resource_group  = "${local.prefix}-d-fdr-sec-rg"
  uat_fdr_key_vault_resource_group  = "${local.prefix}-u-fdr-sec-rg"
  prod_fdr_key_vault_resource_group = "${local.prefix}-p-fdr-sec-rg"

  dev_fdr_key_vault_name  = "${local.prefix}-d-fdr-kv"
  uat_fdr_key_vault_name  = "${local.prefix}-u-fdr-kv"
  prod_fdr_key_vault_name = "${local.prefix}-p-fdr-kv"

  dev_aca_key_vault_resource_group  = "${local.prefix}-d-aca-sec-rg"
  uat_aca_key_vault_resource_group  = "${local.prefix}-u-aca-sec-rg"
  prod_aca_key_vault_resource_group = "${local.prefix}-p-aca-sec-rg"

  dev_aca_key_vault_name  = "${local.prefix}-d-aca-kv"
  uat_aca_key_vault_name  = "${local.prefix}-u-aca-kv"
  prod_aca_key_vault_name = "${local.prefix}-p-aca-kv"

  dev_qi_key_vault_resource_group  = "${local.prefix}-d-qi-sec-rg"
  uat_qi_key_vault_resource_group  = "${local.prefix}-u-qi-sec-rg"
  prod_qi_key_vault_resource_group = "${local.prefix}-p-qi-sec-rg"

  dev_qi_key_vault_name  = "${local.prefix}-d-qi-kv"
  uat_qi_key_vault_name  = "${local.prefix}-u-qi-kv"
  prod_qi_key_vault_name = "${local.prefix}-p-qi-kv"

  #
  # Permissions
  #
  iac_plan_permissions = [
    "PagoPA IaC Reader",
    "Reader",
    "Reader and Data Access",
    "Storage Blob Data Reader",
    "Storage File Data SMB Share Reader",
    "Storage Queue Data Reader",
    "Storage Table Data Reader",
    "Virtual Machine Contributor", #Microsoft.Storage/storageAccounts/listKeys/action
    "PagoPA Export Deployments Template",
    "Key Vault Secrets User",
    "DocumentDB Account Contributor",
    "API Management Service Contributor",
  ]

  tlscert_renew_token = "v3"
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

variable "aks_dev_platform_name" {
  type        = string
  description = "AKS DEV platform name"
}

variable "aks_uat_platform_name" {
  type        = string
  description = "AKS UAT platform name"
}

variable "aks_prod_platform_name" {
  type        = string
  description = "AKS PROD platform name"
}

variable "apim_backup" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "backup-apim"
    }
    pipeline = {
      enable_code_review = false
      enable_deploy      = true
    }
  }
}

variable "location" {
  type = string
}
