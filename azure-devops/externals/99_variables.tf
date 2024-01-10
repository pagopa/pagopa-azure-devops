locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "externals"

  dev_subscription_name  = "dev-pagopa"
  uat_subscription_name  = "uat-pagopa"
  prod_subscription_name = "prod-pagopa"
  org_subscription_name = "org"

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

  # dev_ecommerce_key_vault_name  = "${local.prefix}-d-ecommerce-kv"
  # uat_ecommerce_key_vault_name  = "${local.prefix}-u-ecommerce-kv"
  # prod_ecommerce_key_vault_name = "${local.prefix}-p-ecommerce-kv"

  # dev_gps_key_vault_name  = "${local.prefix}-d-gps-kv"
  # uat_gps_key_vault_name  = "${local.prefix}-u-gps-kv"
  # prod_gps_key_vault_name = "${local.prefix}-p-gps-kv"

  # dev_shared_key_vault_name  = "${local.prefix}-d-shared-kv"
  # uat_shared_key_vault_name  = "${local.prefix}-u-shared-kv"
  # prod_shared_key_vault_name = "${local.prefix}-p-shared-kv"

  # dev_afm_key_vault_name  = "${local.prefix}-d-afm-kv"
  # uat_afm_key_vault_name  = "${local.prefix}-u-afm-kv"
  # prod_afm_key_vault_name = "${local.prefix}-p-afm-kv"

  # dev_kibana_key_vault_name  = "${local.prefix}-d-elk-kv"
  # uat_kibana_key_vault_name  = "${local.prefix}-u-elk-kv"
  # prod_kibana_key_vault_name = "${local.prefix}-p-elk-kv"
  # # KV RG



  # dev_ecommerce_key_vault_resource_group  = "${local.prefix}-d-ecommerce-sec-rg"
  # uat_ecommerce_key_vault_resource_group  = "${local.prefix}-u-ecommerce-sec-rg"
  # prod_ecommerce_key_vault_resource_group = "${local.prefix}-p-ecommerce-sec-rg"

  # dev_gps_key_vault_resource_group  = "${local.prefix}-d-gps-sec-rg"
  # uat_gps_key_vault_resource_group  = "${local.prefix}-u-gps-sec-rg"
  # prod_gps_key_vault_resource_group = "${local.prefix}-p-gps-sec-rg"

  # dev_shared_key_vault_resource_group  = "${local.prefix}-d-shared-sec-rg"
  # uat_shared_key_vault_resource_group  = "${local.prefix}-u-shared-sec-rg"
  # prod_shared_key_vault_resource_group = "${local.prefix}-p-shared-sec-rg"

  # dev_afm_key_vault_resource_group  = "${local.prefix}-d-afm-sec-rg"
  # uat_afm_key_vault_resource_group  = "${local.prefix}-u-afm-sec-rg"
  # prod_afm_key_vault_resource_group = "${local.prefix}-p-afm-sec-rg"


  # dev_kibana_key_vault_resource_group  = "${local.prefix}-d-elk-sec-rg"
  # uat_kibana_key_vault_resource_group  = "${local.prefix}-u-elk-sec-rg"
  # prod_kibana_key_vault_resource_group = "${local.prefix}-p-elk-sec-rg"
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
