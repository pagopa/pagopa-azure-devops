variable "tlscert-weuuat-qi-internal-uat-platform-pagopa-it" {
  default = {
    repository = {
      organization   = "pagopa"
      name           = "le-azure-acme-tiny"
      branch_name    = "refs/heads/master"
      pipelines_path = "."
    }
    pipeline = {
      enable_tls_cert         = true
      path                    = "TLS-Certificates\\UAT"
      dns_record_name         = "weuuat.qi.internal"
      dns_zone_name           = "uat.platform.pagopa.it"
      dns_zone_resource_group = "pagopa-u-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-u-qi-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-weuuat-qi-internal-uat-platform-pagopa-it = {
    tenant_id         = module.secrets.values["TENANTID"].value
    subscription_name = "UAT-PAGOPA"
    subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
  }
  tlscert-weuuat-qi-internal-uat-platform-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.UAT-QI-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-weuuat-qi-internal-uat-platform-pagopa-it-variables_secret = {
  }
}

module "tlscert-weuuat-qi-internal-uat-platform-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert?ref=v2.7.0"
  count  = var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id = data.azuredevops_project.project.id
  repository = var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.repository
  name       = "${var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.dns_record_name}.${var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.dns_zone_name}"
  #tfsec:ignore:GEN003
  renew_token                  = local.tlscert_renew_token
  path                         = var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.path
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id

  dns_record_name         = var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id               = local.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.tenant_id
  subscription_name       = local.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.subscription_name
  subscription_id         = local.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.subscription_id

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_qi_key_vault_name
  credential_key_vault_resource_group = local.uat_qi_key_vault_resource_group

  variables = merge(
    var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.variables,
    local.tlscert-weuuat-qi-internal-uat-platform-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-weuuat-qi-internal-uat-platform-pagopa-it.pipeline.variables_secret,
    local.tlscert-weuuat-qi-internal-uat-platform-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.UAT-QI-TLS-CERT-SERVICE-CONN.service_endpoint_id,
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
