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
    KEY_VAULT_SERVICE_CONNECTION = module.prod_tls_cert_service_conn.service_endpoint_name
  }
  tlscert-prod-wisp2-pagopa-it-variables_secret = {
  }
}

module "tlscert-prod-wisp2-pagopa-it-cert_az" {
  providers = {
    azurerm = azurerm.prod
  }

  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"
  count  = var.tlscert-prod-wisp2-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = local.tlscert_repository
  path                         = var.tlscert-prod-wisp2-pagopa-it.pipeline.path
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  dns_record_name                      = var.tlscert-prod-wisp2-pagopa-it.pipeline.dns_record_name
  dns_zone_name                        = var.tlscert-prod-wisp2-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group              = var.tlscert-prod-wisp2-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id                            = local.tlscert-prod-wisp2-pagopa-it.tenant_id
  subscription_name                    = local.tlscert-prod-wisp2-pagopa-it.subscription_name
  subscription_id                      = local.tlscert-prod-wisp2-pagopa-it.subscription_id
  managed_identity_resource_group_name = local.prod_identity_rg_name

  location                            = var.location
  credential_key_vault_name           = local.prod_key_vault_name
  credential_key_vault_resource_group = local.prod_key_vault_resource_group

  variables = merge(
    var.tlscert-prod-wisp2-pagopa-it.pipeline.variables,
    local.tlscert-prod-wisp2-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-prod-wisp2-pagopa-it.pipeline.variables_secret,
    local.tlscert-prod-wisp2-pagopa-it-variables_secret,
    local.cert_diff_env_variables_prod
  )

  service_connection_ids_authorization = [
    module.prod_tls_cert_service_conn.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Fri"]
    schedule_only_with_changes = false
    start_hours                = 19
    start_minutes              = 30
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = [local.tlscert_repository.branch_name]
      exclude = []
    }
  }
  cert_diff_variables = local.prod_cert_diff_variables
}
