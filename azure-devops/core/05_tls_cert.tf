locals {
  # DEV
  tls_cert_platform_variables = {
    dev = {
      dns_zone_name                       = "dev.platform.pagopa.it"
      dns_zone_rg                         = "pagopa-d-vnet-rg"
      subscription_name                   = upper(data.azurerm_subscriptions.dev.subscriptions[0].display_name)
      subscription_id                     = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
      credential_key_vault_name           = local.dev_key_vault_name
      credential_key_vault_resource_group = local.dev_key_vault_resource_group
      service_endpoint                    = module.dev_tls_cert_service_conn.service_endpoint_id
      variables = {
        KEY_VAULT_SERVICE_CONNECTION = module.dev_tls_cert_service_conn.service_endpoint_name
      }
      variables_secret = {}
    }
  }
  tls_certificate_platform_core = {
    api-dev-platform-pagopa-it : {
      env             = "dev"
      dns_record_name = "api"
      variables       = {}
      variables_secret = merge(
        local.cert_diff_env_variables_dev
      )
      cert_diff_variables = local.dev_cert_diff_variables
    }
    portal-dev-platform-pagopa-it : {
      env             = "dev"
      dns_record_name = "portal"
      variables       = {}
      variables_secret = merge(
        local.cert_diff_env_variables_dev
      )
      cert_diff_variables = local.dev_cert_diff_variables
    }
    management-dev-platform-pagopa-it : {
      env             = "dev"
      dns_record_name = "management"
      variables       = {}
      variables_secret = merge(
        local.cert_diff_env_variables_dev
      )
      cert_diff_variables = local.dev_cert_diff_variables
    }
    config-dev-platform-pagopa-it : {
      env              = "dev"
      dns_record_name  = "config"
      variables        = {}
      variables_secret = {}
    }
    upload-dev-platform-pagopa-it : {
      env             = "dev"
      dns_record_name = "upload"
      variables       = {}
      variables_secret = merge(
        local.cert_diff_env_variables_dev
      )
      cert_diff_variables = local.dev_cert_diff_variables
    }
  }
}

#tfsec:ignore:general-secrets-no-plaintext-exposure
module "federated_cert_pipeline_platform_dev" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"

  for_each = { for k, v in local.tls_certificate_platform_core : k => v if v.env == "dev" }

  providers = {
    azurerm = azurerm.dev
  }

  location                             = var.location
  managed_identity_resource_group_name = local.dev_identity_rg_name

  project_id                   = azuredevops_project.project.id
  repository                   = local.tlscert_repository
  path                         = "TLS-Certificates\\${upper(each.value.env)}"
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-ro.id

  dns_record_name         = each.value.dns_record_name
  dns_zone_name           = local.tls_cert_platform_variables[each.value.env].dns_zone_name
  dns_zone_resource_group = local.tls_cert_platform_variables[each.value.env].dns_zone_rg
  tenant_id               = data.azurerm_client_config.current.tenant_id
  subscription_name       = local.tls_cert_platform_variables[each.value.env].subscription_name
  subscription_id         = local.tls_cert_platform_variables[each.value.env].subscription_id

  credential_key_vault_name           = local.tls_cert_platform_variables[each.value.env].credential_key_vault_name
  credential_key_vault_resource_group = local.tls_cert_platform_variables[each.value.env].credential_key_vault_resource_group

  variables = merge(
    local.tls_cert_platform_variables[each.value.env].variables,
    each.value.variables
  )

  variables_secret = merge(
    local.tls_cert_platform_variables[each.value.env].variables_secret,
    each.value.variables_secret
  )

  service_connection_ids_authorization = [local.tls_cert_platform_variables[each.value.env].service_endpoint]

  schedules = {
    days_to_build              = try(each.value.schedules.days_to_build, ["Fri"])
    schedule_only_with_changes = false
    start_hours                = try(each.value.schedules.start_hours, 3)
    start_minutes              = try(each.value.schedules.start_minutes, 20)
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = [local.tlscert_repository.branch_name]
      exclude = []
    }
  }
  cert_diff_variables = {
    enabled           = try(each.value.cert_diff_variables.enabled, false)
    alert_enabled     = try(each.value.cert_diff_variables.alert_enabled, false)
    cert_diff_version = try(each.value.cert_diff_variables.cert_diff_version, "")
    app_insights_name = try(each.value.cert_diff_variables.app_insights_name, "")
    app_insights_rg   = try(each.value.cert_diff_variables.app_insights_rg, "")
    actions_group     = try(each.value.cert_diff_variables.actions_group, [""])
  }
}
