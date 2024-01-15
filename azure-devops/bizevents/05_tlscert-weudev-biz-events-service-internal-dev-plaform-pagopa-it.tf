variable "tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it" {
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
      dns_record_name         = "weudev.bizevents.internal"
      dns_zone_name           = "dev.platform.pagopa.it"
      dns_zone_resource_group = "pagopa-d-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-d-bizevents-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "DEV-PAGOPA"
    subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  }
  tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.DEV-BIZEVENTS-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it-variables_secret = {
  }
}

module "tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated?ref=v4.1.5"
  count  = var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.repository
  path                         = var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.pipeline.path
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id

  dns_record_name         = var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id               = local.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.tenant_id
  subscription_name       = local.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.subscription_name
  subscription_id         = local.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.subscription_id

  credential_key_vault_name           = local.dev_biz_key_vault_name
  credential_key_vault_resource_group = local.dev_biz_key_vault_resource_group
  location                            = local.location

  variables = merge(
    var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.pipeline.variables,
    local.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it.pipeline.variables_secret,
    local.tlscert-weudev-biz-events-service-internal-dev-platform-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.DEV-BIZEVENTS-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Fri"]
    schedule_only_with_changes = false
    start_hours                = 3
    start_minutes              = 5
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
