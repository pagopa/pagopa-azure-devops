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

locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"

  # 🔐 KV
  dev_key_vault_name  = "${local.prefix}-d-kv-neu"
  uat_key_vault_name  = "${local.prefix}-u-kv-neu"
  prod_key_vault_name = "${local.prefix}-p-kv-weu"

  dev_key_vault_resource_group  = "${local.prefix}-d-sec-rg-neu"
  uat_key_vault_resource_group  = "${local.prefix}-u-sec-rg-neu"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg-weu"

  # ☁️ VNET
  dev_vnet_rg  = "${local.prefix}-d-vnet-rg"
  uat_vnet_rg  = "${local.prefix}-u-vnet-rg"
  prod_vnet_rg = "${local.prefix}-p-vnet-rg"

  # 📦 ACR DEV DOCKER
  srv_endpoint_docker_registry_dev = "${local.prefix}-azurecr-dev"
  docker_registry_rg_name_dev      = "${local.prefix}-d-docker-rg"
  docker_registry_name_dev         = "${local.prefix}dacr"

  # 📦 ACR UAT DOCKER
  srv_endpoint_docker_registry_uat = "${local.prefix}-azurecr-uat"
  docker_registry_rg_name_uat      = "${local.prefix}-u-docker-rg"
  docker_registry_name_uat         = "${local.prefix}uacr"

  # 📦 ACR PROD DOCKER
  srv_endpoint_docker_registry_prod = "${local.prefix}-azurecr-prod"
  docker_registry_rg_name_prod      = "${local.prefix}-p-docker-rg"
  docker_registry_name_prod         = "${local.prefix}pacr"

  #tfsec:ignore:general-secrets-no-plaintext-exposure
  #tfsec:ignore:GEN002
  tlscert_renew_token = "v1"
}
