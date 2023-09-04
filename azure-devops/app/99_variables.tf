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

locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"

  # 🔐 KV
  dev_key_vault_azdo_name  = "${local.prefix}-d-azdo-weu-kv"
  uat_key_vault_azdo_name  = "${local.prefix}-u-azdo-weu-kv"
  prod_key_vault_azdo_name = "${local.prefix}-p-azdo-weu-kv"

  dev_key_vault_name  = "${local.prefix}-d-kv"
  uat_key_vault_name  = "${local.prefix}-u-kv"
  prod_key_vault_name = "${local.prefix}-p-kv"

  dev_ecommerce_key_vault_name  = "${local.prefix}-d-ecommerce-kv"
  uat_ecommerce_key_vault_name  = "${local.prefix}-u-ecommerce-kv"
  prod_ecommerce_key_vault_name = "${local.prefix}-p-ecommerce-kv"

  dev_gps_key_vault_name  = "${local.prefix}-d-gps-kv"
  uat_gps_key_vault_name  = "${local.prefix}-u-gps-kv"
  prod_gps_key_vault_name = "${local.prefix}-p-gps-kv"

  dev_shared_key_vault_name  = "${local.prefix}-d-shared-kv"
  uat_shared_key_vault_name  = "${local.prefix}-u-shared-kv"
  prod_shared_key_vault_name = "${local.prefix}-p-shared-kv"

  dev_afm_key_vault_name  = "${local.prefix}-d-afm-kv"
  uat_afm_key_vault_name  = "${local.prefix}-u-afm-kv"
  prod_afm_key_vault_name = "${local.prefix}-p-afm-kv"

  dev_kibana_key_vault_name  = "${local.prefix}-d-elk-kv"
  uat_kibana_key_vault_name  = "${local.prefix}-u-elk-kv"
  prod_kibana_key_vault_name = "${local.prefix}-p-elk-kv"
  # KV RG

  dev_key_vault_resource_group  = "${local.prefix}-d-sec-rg"
  uat_key_vault_resource_group  = "${local.prefix}-u-sec-rg"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  dev_ecommerce_key_vault_resource_group  = "${local.prefix}-d-ecommerce-sec-rg"
  uat_ecommerce_key_vault_resource_group  = "${local.prefix}-u-ecommerce-sec-rg"
  prod_ecommerce_key_vault_resource_group = "${local.prefix}-p-ecommerce-sec-rg"

  dev_gps_key_vault_resource_group  = "${local.prefix}-d-gps-sec-rg"
  uat_gps_key_vault_resource_group  = "${local.prefix}-u-gps-sec-rg"
  prod_gps_key_vault_resource_group = "${local.prefix}-p-gps-sec-rg"

  dev_shared_key_vault_resource_group  = "${local.prefix}-d-shared-sec-rg"
  uat_shared_key_vault_resource_group  = "${local.prefix}-u-shared-sec-rg"
  prod_shared_key_vault_resource_group = "${local.prefix}-p-shared-sec-rg"

  dev_afm_key_vault_resource_group  = "${local.prefix}-d-afm-sec-rg"
  uat_afm_key_vault_resource_group  = "${local.prefix}-u-afm-sec-rg"
  prod_afm_key_vault_resource_group = "${local.prefix}-p-afm-sec-rg"


  dev_kibana_key_vault_resource_group  = "${local.prefix}-d-elk-sec-rg"
  uat_kibana_key_vault_resource_group  = "${local.prefix}-u-elk-sec-rg"
  prod_kibana_key_vault_resource_group = "${local.prefix}-p-elk-sec-rg"
  # ☁️ VNET
  dev_vnet_rg  = "${local.prefix}-d-vnet-rg"
  uat_vnet_rg  = "${local.prefix}-u-vnet-rg"
  prod_vnet_rg = "${local.prefix}-p-vnet-rg"

  # 📦 ACR DEV DOCKER
  srv_endpoint_name_docker_registry_dev = "${local.prefix}-azurecr-dev"
  docker_registry_rg_name_dev           = "${local.prefix}-d-container-registry-rg"
  docker_registry_name_dev              = "${local.prefix}dcommonacr"

  # 📦 ACR UAT DOCKER
  srv_endpoint_name_docker_registry_uat = "${local.prefix}-azurecr-uat"
  docker_registry_rg_name_uat           = "${local.prefix}-u-container-registry-rg"
  docker_registry_name_uat              = "${local.prefix}ucommonacr"

  # 📦 ACR PROD DOCKER
  srv_endpoint_name_docker_registry_prod = "${local.prefix}-azurecr-prod"
  docker_registry_rg_name_prod           = "${local.prefix}-p-container-registry-rg"
  docker_registry_name_prod              = "${local.prefix}pcommonacr"

  # 📦 ACR DEV FOR AKS
  srv_endpoint_name_aks_cr_dev = "${local.prefix}-aks-cr-dev"
  aks_cr_rg_name_dev           = "${local.prefix}-d-container-registry-rg"
  aks_cr_name_dev              = "${local.prefix}dcommonacr"

  # 📦 ACR UAT FOR AKS
  srv_endpoint_name_aks_cr_uat = "${local.prefix}-aks-cr-uat"
  aks_cr_rg_name_uat           = "${local.prefix}-u-container-registry-rg"
  aks_cr_name_uat              = "${local.prefix}ucommonacr"

  # 📦 ACR PROD FOR AKS
  srv_endpoint_name_aks_cr_prod = "${local.prefix}-aks-cr-prod"
  aks_cr_rg_name_prod           = "${local.prefix}-p-container-registry-rg"
  aks_cr_name_prod              = "${local.prefix}pcommonacr"

  srv_endpoint_name_aks_dev  = "${local.prefix}-aks-dev"
  srv_endpoint_name_aks_uat  = "${local.prefix}-aks-uat"
  srv_endpoint_name_aks_prod = "${local.prefix}-aks-prod"

  #tfsec:ignore:general-secrets-no-plaintext-exposure
  #tfsec:ignore:GEN002
  tlscert_renew_token        = "v1"
  tlscert_renew_token_kibana = "v2"
  # Service connections/ End points
  srv_endpoint_github_ro = "io-azure-devops-github-ro"
  srv_endpoint_github_rw = "io-azure-devops-github-rw"
  srv_endpoint_github_pr = "io-azure-devops-github-pr"

  # TODO azure devops terraform provider does not support SonarCloud service endpoint
  azuredevops_serviceendpoint_sonarcloud_id = "9182be64-d387-465d-9acc-e79e802910c8"
}
