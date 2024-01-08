variable "tlscert-prod-wisp2-pagopa-it" {
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
      dns_record_name         = ""
      dns_zone_name           = "wisp2.pagopa.it"
      dns_zone_resource_group = "pagopa-p-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-p-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-prod-wisp2-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "PROD-PAGOPA"
    subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  }
  tlscert-prod-wisp2-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.PROD-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-prod-wisp2-pagopa-it-variables_secret = {
  }
}

module "tlscert-prod-wisp2-pagopa-it-cert_az" {
  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated?ref=v4.1.4"
  count  = var.tlscert-prod-wisp2-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id = azuredevops_project.project.id
  repository = var.tlscert-prod-wisp2-pagopa-it.repository
  path                         = var.tlscert-prod-wisp2-pagopa-it.pipeline.path
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  dns_record_name         = var.tlscert-prod-wisp2-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-prod-wisp2-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = var.tlscert-prod-wisp2-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id               = local.tlscert-prod-wisp2-pagopa-it.tenant_id
  subscription_name       = local.tlscert-prod-wisp2-pagopa-it.subscription_name
  subscription_id         = local.tlscert-prod-wisp2-pagopa-it.subscription_id

  location = var.location
  credential_key_vault_name           = local.prod_key_vault_name
  credential_key_vault_resource_group = local.prod_key_vault_resource_group

  variables = merge(
    var.tlscert-prod-wisp2-pagopa-it.pipeline.variables,
    local.tlscert-prod-wisp2-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-prod-wisp2-pagopa-it.pipeline.variables_secret,
    local.tlscert-prod-wisp2-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.PROD-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Wed"]
    schedule_only_with_changes = false
    start_hours                = 9
    start_minutes              = 30
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["master"]
      exclude = []
    }
  }
}
