variable "tlscert-crusc8-prod-platform-pagopa-it" {
  default = {
    repository = {
      organization   = "pagopa"
      name           = "le-azure-acme-tiny"
      branch_name    = "refs/heads/master"
      pipelines_path = "."
    }
    pipeline = {
      enable_tls_cert         = true
      path                    = "TLS-Certificates\\PROD"
      dns_record_name         = "crusc8"
      dns_zone_name           = "platform.pagopa.it"
      dns_zone_resource_group = "pagopa-p-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-p-itn-crusc8-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-crusc8-prod-platform-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "PROD-PAGOPA"
    subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  }
  tlscert-crusc8-prod-platform-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.PROD-CRUSC8-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-crusc8-prod-platform-pagopa-it-variables_secret = {
  }
}

module "tlscert-crusc8-prod-platform-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"

  count = var.tlscert-crusc8-prod-platform-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.tlscert-crusc8-prod-platform-pagopa-it.repository
  path                         = var.tlscert-crusc8-prod-platform-pagopa-it.pipeline.path
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id

  dns_record_name                      = var.tlscert-crusc8-prod-platform-pagopa-it.pipeline.dns_record_name
  dns_zone_name                        = var.tlscert-crusc8-prod-platform-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group              = var.tlscert-crusc8-prod-platform-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id                            = local.tlscert-crusc8-prod-platform-pagopa-it.tenant_id
  subscription_name                    = local.tlscert-crusc8-prod-platform-pagopa-it.subscription_name
  subscription_id                      = local.tlscert-crusc8-prod-platform-pagopa-it.subscription_id
  location                             = local.location_westeurope
  credential_key_vault_name            = local.prod_crusc8_key_vault_name
  credential_key_vault_resource_group  = local.prod_crusc8_key_vault_resource_group
  managed_identity_resource_group_name = local.prod_identity_rg_name

  variables = merge(
    var.tlscert-crusc8-prod-platform-pagopa-it.pipeline.variables,
    local.tlscert-crusc8-prod-platform-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-crusc8-prod-platform-pagopa-it.pipeline.variables_secret,
    local.tlscert-crusc8-prod-platform-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.PROD-CRUSC8-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Fri"]
    schedule_only_with_changes = false
    start_hours                = 3
    start_minutes              = 0
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["master"]
      exclude = []
    }
  }

}
