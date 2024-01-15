variable "tlscert-weudev-mock-internal-dev-platform-pagopa-it" {
  default = {
    repository = {
      organization   = "pagopa"
      name           = "le-azure-acme-tiny"
      branch_name    = "refs/heads/master"
      pipelines_path = "."
    }
    pipeline = {
      enable_tls_cert         = true
      path                    = "TLS-Certificates\\DEV"
      dns_record_name         = "weudev.mock.internal"
      dns_zone_name           = "dev.platform.pagopa.it"
      dns_zone_resource_group = "pagopa-d-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-d-mock-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-weudev-mock-internal-dev-platform-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "DEV-PAGOPA"
    subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  }
  tlscert-weudev-mock-internal-dev-platform-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.DEV-MOCK-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-weudev-mock-internal-dev-platform-pagopa-it-variables_secret = {
  }
}

module "tlscert-weudev-mock-internal-dev-platform-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated?ref=v4.2.1"
  count  = var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.repository
  path                         = var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.pipeline.path
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id

  dns_record_name         = var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id               = local.tlscert-weudev-mock-internal-dev-platform-pagopa-it.tenant_id
  subscription_name       = local.tlscert-weudev-mock-internal-dev-platform-pagopa-it.subscription_name
  subscription_id         = local.tlscert-weudev-mock-internal-dev-platform-pagopa-it.subscription_id

  location                            = var.location
  credential_key_vault_name           = local.dev_mock_key_vault_name
  credential_key_vault_resource_group = local.dev_mock_key_vault_resource_group

  variables = merge(
    var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.pipeline.variables,
    local.tlscert-weudev-mock-internal-dev-platform-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-weudev-mock-internal-dev-platform-pagopa-it.pipeline.variables_secret,
    local.tlscert-weudev-mock-internal-dev-platform-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.DEV-MOCK-TLS-CERT-SERVICE-CONN.service_endpoint_id,
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

  depends_on = [
    module.letsencrypt_dev
  ]
}
