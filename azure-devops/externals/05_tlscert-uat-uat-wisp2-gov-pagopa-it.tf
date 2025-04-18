variable "tlscert-uat-uat-wisp2-gov-pagopa-it" {
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
      dns_record_name         = "uat.wisp2"
      dns_zone_name           = "pagopa.gov.it"
      dns_zone_resource_group = "pagopaorg-rg-prod"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-u-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-uat-uat-wisp2-gov-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "ORG"
    subscription_id   = module.secrets.values["ORG-SUBSCRIPTION-ID"].value
  }
  tlscert-uat-uat-wisp2-gov-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.UAT-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED.service_endpoint_name
  }
  tlscert-uat-uat-wisp2-gov-pagopa-it-variables_secret = {
  }
}

module "tlscert-uat-uat-wisp2-gov-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"
  count  = var.tlscert-uat-uat-wisp2-gov-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.tlscert-uat-uat-wisp2-gov-pagopa-it.repository
  path                         = var.tlscert-uat-uat-wisp2-gov-pagopa-it.pipeline.path
  github_service_connection_id = data.azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  dns_record_name                      = var.tlscert-uat-uat-wisp2-gov-pagopa-it.pipeline.dns_record_name
  dns_zone_name                        = var.tlscert-uat-uat-wisp2-gov-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group              = var.tlscert-uat-uat-wisp2-gov-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id                            = local.tlscert-uat-uat-wisp2-gov-pagopa-it.tenant_id
  subscription_name                    = local.tlscert-uat-uat-wisp2-gov-pagopa-it.subscription_name
  subscription_id                      = local.tlscert-uat-uat-wisp2-gov-pagopa-it.subscription_id
  managed_identity_resource_group_name = local.uat_identity_rg_name

  location                            = var.location
  credential_key_vault_name           = local.uat_key_vault_name
  credential_key_vault_resource_group = local.uat_key_vault_resource_group

  variables = merge(
    var.tlscert-uat-uat-wisp2-gov-pagopa-it.pipeline.variables,
    local.tlscert-uat-uat-wisp2-gov-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-uat-uat-wisp2-gov-pagopa-it.pipeline.variables_secret,
    local.tlscert-uat-uat-wisp2-gov-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.UAT-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Fri"]
    schedule_only_with_changes = false
    start_hours                = 16
    start_minutes              = 35
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["master"]
      exclude = []
    }
  }
}
