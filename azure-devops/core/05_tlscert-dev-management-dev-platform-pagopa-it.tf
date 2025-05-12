variable "tlscert-dev-management-dev-platform-pagopa-it" {
  default = {
    pipeline = {
      enable_tls_cert         = true
      path                    = "TLS-Certificates\\DEV"
      dns_record_name         = "management"
      dns_zone_name           = "dev.platform.pagopa.it"
      dns_zone_resource_group = "pagopa-d-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-d-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-dev-management-dev-platform-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "DEV-PAGOPA"
    subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  }
  tlscert-dev-management-dev-platform-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.DEV-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-dev-management-dev-platform-pagopa-it-variables_secret = {
  }
}

module "tlscert-dev-management-dev-platform-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"
  count  = var.tlscert-dev-management-dev-platform-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = local.tlscert_repository
  path                         = var.tlscert-dev-management-dev-platform-pagopa-it.pipeline.path
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  dns_record_name                      = var.tlscert-dev-management-dev-platform-pagopa-it.pipeline.dns_record_name
  dns_zone_name                        = var.tlscert-dev-management-dev-platform-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group              = var.tlscert-dev-management-dev-platform-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id                            = local.tlscert-dev-management-dev-platform-pagopa-it.tenant_id
  subscription_name                    = local.tlscert-dev-management-dev-platform-pagopa-it.subscription_name
  subscription_id                      = local.tlscert-dev-management-dev-platform-pagopa-it.subscription_id
  managed_identity_resource_group_name = local.dev_identity_rg_name

  location                            = var.location
  credential_key_vault_name           = local.dev_key_vault_name
  credential_key_vault_resource_group = local.dev_key_vault_resource_group

  variables = merge(
    var.tlscert-dev-management-dev-platform-pagopa-it.pipeline.variables,
    local.tlscert-dev-management-dev-platform-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-dev-management-dev-platform-pagopa-it.pipeline.variables_secret,
    local.tlscert-dev-management-dev-platform-pagopa-it-variables_secret,
    local.cert_diff_variables
  )

  service_connection_ids_authorization = [
    module.DEV-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Fri"]
    schedule_only_with_changes = false
    start_hours                = 3
    start_minutes              = 20
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = [local.tlscert_repository.branch_name]
      exclude = []
    }
  }
  cert_diff_pipeline_enabled = true
}
