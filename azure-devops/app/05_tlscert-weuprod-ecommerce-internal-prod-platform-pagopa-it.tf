variable "tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it" {
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
      dns_record_name         = "weuprod.ecommerce.internal"
      dns_zone_name           = "platform.pagopa.it"
      dns_zone_resource_group = "pagopa-p-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-p-ecommerce-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it = {
    tenant_id         = data.azurerm_client_config.current.tenant_id
    subscription_name = "PROD-PAGOPA"
    subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  }
  tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.PROD-ECOMMERCE-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it-variables_secret = {
  }
}

module "tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it-cert_az" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert?ref=v4.1.4"
  count  = var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id = azuredevops_project.project.id
  repository = var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.repository
  name       = "${var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.dns_record_name}.${var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.dns_zone_name}"
  #tfsec:ignore:GEN003
  renew_token                  = local.tlscert_renew_token
  path                         = var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.path
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  dns_record_name         = var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id               = local.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.tenant_id
  subscription_name       = local.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.subscription_name
  subscription_id         = local.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.subscription_id

  credential_subcription              = var.prod_subscription_name
  credential_key_vault_name           = local.prod_ecommerce_key_vault_name
  credential_key_vault_resource_group = local.prod_ecommerce_key_vault_resource_group

  variables = merge(
    var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.variables,
    local.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it.pipeline.variables_secret,
    local.tlscert-weuprod-ecommerce-internal-prod-platform-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.PROD-ECOMMERCE-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = {
    days_to_build              = ["Wed"]
    schedule_only_with_changes = false
    start_hours                = 7
    start_minutes              = 0
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["master"]
      exclude = []
    }
  }
}
