variable "tlscert-prod-ecommerce-pagopa-it" {
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
      dns_zone_name           = "ecommerce.pagopa.it"
      dns_zone_resource_group = "pagopa-p-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = local.prod_ecommerce_key_vault_name
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-prod-ecommerce-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "PROD-PAGOPA"
    subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  }
  tlscert-prod-ecommerce-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.PROD-ECOMMERCE-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-prod-ecommerce-pagopa-it-variables_secret = {
  }
}

module "tlscert-prod-ecommerce-pagopa-it-cert_az" {
  providers = {
    azurerm = azurerm.prod
  }

  source = "../core/.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"
  count  = var.tlscert-prod-ecommerce-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id                   = var.project_name.id
  repository                   = var.tlscert-prod-ecommerce-pagopa-it.repository
  path                         = var.tlscert-prod-ecommerce-pagopa-it.pipeline.path
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.id

  dns_record_name                      = var.tlscert-prod-ecommerce-pagopa-it.pipeline.dns_record_name
  dns_zone_name                        = var.tlscert-prod-ecommerce-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group              = var.tlscert-prod-ecommerce-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id                            = local.tlscert-prod-ecommerce-pagopa-it.tenant_id
  subscription_name                    = local.tlscert-prod-ecommerce-pagopa-it.subscription_name
  subscription_id                      = local.tlscert-prod-ecommerce-pagopa-it.subscription_id
  managed_identity_resource_group_name = local.prod_identity_rg_name

  location                            = local.location
  credential_key_vault_name           = local.prod_ecommerce_key_vault_name
  credential_key_vault_resource_group = local.prod_key_vault_resource_group

  variables = merge(
    var.tlscert-prod-ecommerce-pagopa-it.pipeline.variables,
    local.tlscert-prod-ecommerce-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-prod-ecommerce-pagopa-it.pipeline.variables_secret,
    local.tlscert-prod-ecommerce-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.PROD-ECOMMERCE-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Fri"]
    schedule_only_with_changes = false
    start_hours                = 17
    start_minutes              = 5
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["master"]
      exclude = []
    }
  }
}
