variable "tlscert-weuprod-shared-internal-prod-platform-pagopa-it" {
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
      dns_record_name         = "weuprod.shared.internal"
      dns_zone_name           = "platform.pagopa.it"
      dns_zone_resource_group = "pagopa-p-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-p-shared-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-weuprod-shared-internal-prod-platform-pagopa-it = {
    tenant_id         = module.secrets.values["TENANTID"].value
    subscription_name = "PROD-PAGOPA"
    subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
  }
  tlscert-weuprod-shared-internal-prod-platform-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.PROD-SHARED-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-weuprod-shared-internal-prod-platform-pagopa-it-variables_secret = {
  }
}

module "tlscert-weuprod-shared-internal-prod-platform-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert?ref=v2.6.5"
  count  = var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id = azuredevops_project.project.id
  repository = var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.repository
  name       = "${var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.dns_record_name}.${var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.dns_zone_name}"
  #tfsec:ignore:GEN003
  renew_token                  = local.tlscert_renew_token
  path                         = var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.path
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-ro.id

  dns_record_name         = var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id               = local.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.tenant_id
  subscription_name       = local.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.subscription_name
  subscription_id         = local.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.subscription_id

  credential_subcription              = var.prod_subscription_name
  credential_key_vault_name           = local.prod_shared_key_vault_name
  credential_key_vault_resource_group = local.prod_shared_key_vault_resource_group

  variables = merge(
    var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.variables,
    local.tlscert-weuprod-shared-internal-prod-platform-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-weuprod-shared-internal-prod-platform-pagopa-it.pipeline.variables_secret,
    local.tlscert-weuprod-shared-internal-prod-platform-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.PROD-SHARED-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Mon"]
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
