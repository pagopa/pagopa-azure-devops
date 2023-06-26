variable "dev_subscription_name" {
  type        = string
  description = "DEV Subscription name"
}

variable "uat_subscription_name" {
  type        = string
  description = "UAT Subscription name"
}

variable "project_name" {
  type        = string
  description = "Project name (e.g. pagoPA platform)"
}

variable "pipeline_environments" {
  type        = list(any)
  description = "List of environments pipeline to create"
}

variable "terraform_remote_state_app" {
  type = object({
    resource_group_name  = string,
    storage_account_name = string,
    container_name       = string,
    key                  = string
  })
}

locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "mock"

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


  # 🔐 KV DOMAIN
  dev_mock_key_vault_name  = "${local.prefix}-d-${local.domain}-kv"
  uat_mock_key_vault_name  = "${local.prefix}-u-${local.domain}-kv"

  dev_mock_key_vault_resource_group  = "${local.prefix}-d-${local.domain}-sec-rg"
  uat_mock_key_vault_resource_group  = "${local.prefix}-u-${local.domain}-sec-rg"

  # ☁️ VNET
  dev_vnet_rg  = "${local.prefix}-d-vnet-rg"
  uat_vnet_rg  = "${local.prefix}-u-vnet-rg"

  # 📦 ACR DEV FOR AKS
  srv_endpoint_name_aks_cr_dev = "${local.prefix}-aks-cr-dev"
  aks_cr_rg_name_dev           = "${local.prefix}-d-container-registry-rg"
  aks_cr_name_dev              = "${local.prefix}dcommonacr"

  # 📦 ACR UAT FOR AKS
  srv_endpoint_name_aks_cr_uat = "${local.prefix}-aks-cr-uat"
  aks_cr_rg_name_uat           = "${local.prefix}-u-container-registry-rg"
  aks_cr_name_uat              = "${local.prefix}ucommonacr"

  settings_xml_ro_secure_file_name = "settings-ro.xml"

  srv_endpoint_name_aks_dev  = "${local.prefix}-${local.domain}-aks-dev"
  srv_endpoint_name_aks_uat  = "${local.prefix}-${local.domain}-aks-uat"

  #tfsec:ignore:general-secrets-no-plaintext-exposure
  #tfsec:ignore:GEN002
  tlscert_renew_token = "v6"

  # TODO azure devops terraform provider does not support SonarCloud service endpoint
  azuredevops_serviceendpoint_sonarcloud_id = "9182be64-d387-465d-9acc-e79e802910c8"

  appinsights_renew_token         = "v1"
  dev_appinsights_name            = "${local.prefix}-d-appinsights"
  uat_appinsights_name            = "${local.prefix}-u-appinsights"
  dev_appinsights_resource_group  = "${local.prefix}-d-monitor-rg"
  uat_appinsights_resource_group  = "${local.prefix}-u-monitor-rg"
}
