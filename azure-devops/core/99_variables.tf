locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "core"

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


  # ☁️ VNET
  dev_vnet_rg  = "${local.prefix}-d-vnet-rg"
  uat_vnet_rg  = "${local.prefix}-u-vnet-rg"
  prod_vnet_rg = "${local.prefix}-p-vnet-rg"

  # 📦 🇪🇺 WEST - ACR DEV DOCKER
  srv_endpoint_name_docker_registry_dev = "${local.prefix}-azurecr-dev"
  docker_registry_rg_name_dev           = "${local.prefix}-d-container-registry-rg"
  docker_registry_name_dev              = "${local.prefix}dcommonacr"

  # 📦 🇮🇹 ITA - ACR DEV DOCKER
  srv_endpoint_name_docker_registry_italy_dev = "${local.prefix}-azurecr-ita-dev"
  docker_registry_italy_rg_name_dev           = "${local.prefix}-d-itn-acr-rg"
  docker_registry_italy_name_dev              = "${local.prefix}ditncoreacr"

  # 📦 🇪🇺 ACR WEU UAT DOCKER
  srv_endpoint_name_docker_registry_uat = "${local.prefix}-azurecr-uat"
  docker_registry_rg_name_uat           = "${local.prefix}-u-container-registry-rg"
  docker_registry_name_uat              = "${local.prefix}ucommonacr"

  # 📦 🇮🇹 ITA - ACR UAT DOCKER
  srv_endpoint_name_docker_registry_italy_uat = "${local.prefix}-azurecr-ita-uat"
  docker_registry_italy_rg_name_uat           = "${local.prefix}-u-itn-acr-rg"
  docker_registry_italy_name_uat              = "${local.prefix}uitncoreacr"

  # 📦 🇪🇺 WEU - ACR PROD DOCKER
  srv_endpoint_name_docker_registry_prod = "${local.prefix}-azurecr-prod"
  docker_registry_rg_name_prod           = "${local.prefix}-p-container-registry-rg"
  docker_registry_name_prod              = "${local.prefix}pcommonacr"

  # 📦 🇮🇹 ITA - ACR PROD DOCKER
  srv_endpoint_name_docker_registry_italy_prod = "${local.prefix}-azurecr-ita-prod"
  docker_registry_italy_rg_name_prod           = "${local.prefix}-p-itn-acr-rg"
  docker_registry_italy_name_prod              = "${local.prefix}pitncoreacr"

  # 📦 ACR DEV FOR AKS
  srv_endpoint_name_aks_cr_dev = "${local.prefix}-aks-cr-dev"
  aks_cr_rg_name_dev           = "${local.prefix}-d-container-registry-rg"
  aks_cr_name_dev              = "${local.prefix}dcommonacr"

  srv_endpoint_name_aks_cr_itn_dev = "${local.prefix}-aks-cr-itn-dev"
  aks_cr_rg_name_itn_dev           = "${local.prefix}-d-itn-acr-rg"
  aks_cr_name_itn_dev              = "${local.prefix}ditncoreacr"

  # 📦 ACR UAT FOR AKS
  srv_endpoint_name_aks_cr_uat = "${local.prefix}-aks-cr-uat"
  aks_cr_rg_name_uat           = "${local.prefix}-u-container-registry-rg"
  aks_cr_name_uat              = "${local.prefix}ucommonacr"

  srv_endpoint_name_aks_cr_itn_uat = "${local.prefix}-aks-cr-itn-uat"
  aks_cr_rg_name_itn_uat           = "${local.prefix}-u-itn-acr-rg"
  aks_cr_name_itn_uat              = "${local.prefix}uitncoreacr"

  # 📦 ACR PROD FOR AKS
  srv_endpoint_name_aks_cr_prod = "${local.prefix}-aks-cr-prod"
  aks_cr_rg_name_prod           = "${local.prefix}-p-container-registry-rg"
  aks_cr_name_prod              = "${local.prefix}pcommonacr"

  srv_endpoint_name_aks_cr_itn_prod = "${local.prefix}-aks-cr-itn-prod"
  aks_cr_rg_name_itn_prod           = "${local.prefix}-p-itn-acr-rg"
  aks_cr_name_itn_prod              = "${local.prefix}pitncoreacr"

  srv_endpoint_name_aks_dev  = "${local.prefix}-aks-dev"
  srv_endpoint_name_aks_uat  = "${local.prefix}-aks-uat"
  srv_endpoint_name_aks_prod = "${local.prefix}-aks-prod"

  #tfsec:ignore:general-secrets-no-plaintext-exposure
  #tfsec:ignore:GEN002
  tlscert_renew_token = "v3"

  # Service connections/ End points
  srv_endpoint_github_ro = "io-azure-devops-github-ro"
  srv_endpoint_github_rw = "io-azure-devops-github-rw"
  srv_endpoint_github_pr = "io-azure-devops-github-pr"

  # TODO azure devops terraform provider does not support SonarCloud service endpoint
  azuredevops_serviceendpoint_sonarcloud_id = "9182be64-d387-465d-9acc-e79e802910c8"

  # APPINSIGHTS
  dev_app_insight_monitoring_name    = "${local.prefix}-d-weu-synthetic-appinsights"
  dev_app_insight_monitoring_rg      = "${local.prefix}-d-weu-synthetic-rg"
  dev_cert_diff_pipeline_status_name = "${local.prefix}d-cert-pipeline-status"
  dev_monitor_rg                     = "${local.prefix}-d-monitor-rg"

  uat_app_insight_monitoring_name    = "${local.prefix}-u-weu-synthetic-appinsights"
  uat_app_insight_monitoring_rg      = "${local.prefix}-u-weu-synthetic-rg"
  uat_cert_diff_pipeline_status_name = "${local.prefix}u-cert-pipeline-status"
  uat_monitor_rg                     = "${local.prefix}-u-monitor-rg"

  prod_app_insight_monitoring_name    = "${local.prefix}-p-weu-synthetic-appinsights"
  prod_app_insight_monitoring_rg      = "${local.prefix}-p-weu-synthetic-rg"
  prod_cert_diff_pipeline_status_name = "${local.prefix}p-cert-pipeline-status"
  prod_monitor_rg                     = "${local.prefix}-p-monitor-rg"

  # TLS CERT + TLS CERT DIFF
  tlscert_repository = {
    organization   = "pagopa"
    name           = "le-azure-acme-tiny"
    branch_name    = "refs/heads/master"
    pipelines_path = "."
  }

  cert_diff_env_variables_dev = {
    RECEIVER_EMAIL = module.pagopa_core_dev_secrets.values["tls-cert-diff-receiver-emails"].value
    SENDER_EMAIL   = module.pagopa_core_dev_secrets.values["tls-cert-diff-sender-email"].value
    APP_PASS       = module.pagopa_core_dev_secrets.values["tls-cert-diff-sender-email-app-pass"].value
  }

  dev_cert_diff_variables = {
    enabled           = true
    alert_enabled     = true
    cert_diff_version = "0.2.5"
    app_insights_name = local.dev_app_insight_monitoring_name
    app_insights_rg   = local.dev_app_insight_monitoring_rg
    actions_group     = [data.azurerm_monitor_action_group.certificate_pipeline_status_dev.id]
  }

  cert_diff_env_variables_uat = {
    RECEIVER_EMAIL = module.pagopa_core_uat_secrets.values["tls-cert-diff-receiver-emails"].value
    SENDER_EMAIL   = module.pagopa_core_uat_secrets.values["tls-cert-diff-sender-email"].value
    APP_PASS       = module.pagopa_core_uat_secrets.values["tls-cert-diff-sender-email-app-pass"].value
  }

  uat_cert_diff_variables = {
    enabled           = true
    alert_enabled     = true
    cert_diff_version = "0.2.5"
    app_insights_name = local.uat_app_insight_monitoring_name
    app_insights_rg   = local.uat_app_insight_monitoring_rg
    actions_group     = [data.azurerm_monitor_action_group.certificate_pipeline_status_uat.id]
  }

  cert_diff_env_variables_prod = {
    RECEIVER_EMAIL = module.pagopa_core_prod_secrets.values["tls-cert-diff-receiver-emails"].value
    SENDER_EMAIL   = module.pagopa_core_prod_secrets.values["tls-cert-diff-sender-email"].value
    APP_PASS       = module.pagopa_core_prod_secrets.values["tls-cert-diff-sender-email-app-pass"].value
  }

  prod_cert_diff_variables = {
    enabled           = true
    alert_enabled     = true
    cert_diff_version = "0.2.5"
    app_insights_name = local.prod_app_insight_monitoring_name
    app_insights_rg   = local.prod_app_insight_monitoring_rg
    actions_group     = [data.azurerm_monitor_action_group.certificate_pipeline_status_prod.id]
  }

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
