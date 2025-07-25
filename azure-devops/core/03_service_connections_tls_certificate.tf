#
# ⛩ Service connection 2 🔐 KV@DEV 🟢
#
#tfsec:ignore:GEN003
module "dev_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-${local.domain}-d-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  location            = var.location
  resource_group_name = local.dev_identity_rg_name

}

data "azurerm_key_vault" "kv_dev" {
  provider            = azurerm.dev
  name                = local.dev_key_vault_name
  resource_group_name = local.dev_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.dev_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import", "Update"]
  secret_permissions      = ["Get"]
}

#
# ⛩ Service connection 2 🔐 KV@UAT 🟨
#
#tfsec:ignore:GEN003
module "uat_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-${local.domain}-u-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name


  location            = var.location
  resource_group_name = local.uat_identity_rg_name
}

data "azurerm_key_vault" "kv_uat" {
  provider            = azurerm.uat
  name                = local.uat_key_vault_name
  resource_group_name = local.uat_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.kv_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.uat_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import", "Update"]
  secret_permissions      = ["Get"]
}

#
# ⛩ Service connection 2 🔐 KV@PROD 🛑
#
#tfsec:ignore:GEN003
module "prod_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-${local.domain}-p-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name = var.prod_subscription_name

  location            = var.location
  resource_group_name = local.prod_identity_rg_name
}

data "azurerm_key_vault" "kv_prod" {
  provider            = azurerm.prod
  name                = local.prod_key_vault_name
  resource_group_name = local.prod_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider     = azurerm.prod
  key_vault_id = data.azurerm_key_vault.kv_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.prod_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import", "Update"]
  secret_permissions      = ["Get"]
}

#
# ⛩ Service connection 2 🔐 KV-ECOMMERCE@DEV 🟢
#
#tfsec:ignore:GEN003
module "dev_ecommerce_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-ecommerce-d-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  location            = var.location
  resource_group_name = local.dev_identity_rg_name
}

data "azurerm_key_vault" "kv_ecommerce_dev" {
  provider            = azurerm.dev
  name                = local.dev_ecommerce_key_vault_name
  resource_group_name = local.dev_ecommerce_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-ECOMMERCE-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_ecommerce_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.dev_ecommerce_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV-ECOMMERCE@UAT 🟢
#
#tfsec:ignore:GEN003
module "uat_ecommerce_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-ecommerce-u-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  location            = var.location
  resource_group_name = local.uat_identity_rg_name
}

data "azurerm_key_vault" "kv_ecommerce_uat" {
  provider            = azurerm.uat
  name                = local.uat_ecommerce_key_vault_name
  resource_group_name = local.uat_ecommerce_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-ECOMMERCE-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_ecommerce_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.uat_ecommerce_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV-ECOMMERCE@PROD 🟢
#
#tfsec:ignore:GEN003
module "prod_ecommerce_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name                = "${local.prefix}-ecommerce-p-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subscription_id     = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name   = var.prod_subscription_name
  location            = var.location
  resource_group_name = local.prod_identity_rg_name
}

data "azurerm_key_vault" "kv_ecommerce_prod" {
  provider            = azurerm.prod
  name                = local.prod_ecommerce_key_vault_name
  resource_group_name = local.prod_ecommerce_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-ECOMMERCE-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider = azurerm.prod

  key_vault_id = data.azurerm_key_vault.kv_ecommerce_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.prod_ecommerce_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-SHARED@DEV 🟢
#
#tfsec:ignore:GEN003
module "dev_shared_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-shared-d-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name


  location            = var.location
  resource_group_name = local.dev_identity_rg_name
}

data "azurerm_key_vault" "kv_shared_dev" {
  provider            = azurerm.dev
  name                = local.dev_shared_key_vault_name
  resource_group_name = local.dev_shared_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-SHARED-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_shared_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.dev_shared_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-AFM@DEV 🟢
#
#tfsec:ignore:GEN003
module "dev_afm_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-afm-d-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  location            = var.location
  resource_group_name = local.dev_identity_rg_name
}

data "azurerm_key_vault" "kv_afm_dev" {
  provider            = azurerm.dev
  name                = local.dev_afm_key_vault_name
  resource_group_name = local.dev_afm_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-AFM-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_afm_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.dev_afm_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-SHARED@UAT 🟢
#
#tfsec:ignore:GEN003
module "uat_shared_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-shared-u-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  location            = var.location
  resource_group_name = local.uat_identity_rg_name
}

data "azurerm_key_vault" "kv_shared_uat" {
  provider            = azurerm.uat
  name                = local.uat_shared_key_vault_name
  resource_group_name = local.uat_shared_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-SHARED-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_shared_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.uat_shared_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-AFM@UAT 🟢
#
#tfsec:ignore:GEN003
module "uat_afm_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name                = "${local.prefix}-afm-u-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subscription_id     = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name   = var.uat_subscription_name
  location            = var.location
  resource_group_name = local.uat_identity_rg_name

}

data "azurerm_key_vault" "kv_afm_uat" {
  provider            = azurerm.uat
  name                = local.uat_afm_key_vault_name
  resource_group_name = local.uat_afm_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-AFM-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_afm_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.uat_afm_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-SHARED@PROD 🟢
#
#tfsec:ignore:GEN003
module "prod_shared_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name                = "${local.prefix}-shared-p-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subscription_id     = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name   = var.prod_subscription_name
  location            = var.location
  resource_group_name = local.prod_identity_rg_name
}

data "azurerm_key_vault" "kv_shared_prod" {
  provider            = azurerm.prod
  name                = local.prod_shared_key_vault_name
  resource_group_name = local.prod_shared_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-SHARED-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider = azurerm.prod

  key_vault_id = data.azurerm_key_vault.kv_shared_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.prod_shared_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-AFM@PROD 🟢
#
#tfsec:ignore:GEN003
module "prod_afm_tls_cert_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name                = "${local.prefix}-afm-p-${local.domain}-azdo-tls-cert-kv-policy"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subscription_id     = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name   = var.prod_subscription_name
  location            = var.location
  resource_group_name = local.prod_identity_rg_name
}

data "azurerm_key_vault" "kv_afm_prod" {
  provider            = azurerm.prod
  name                = local.prod_afm_key_vault_name
  resource_group_name = local.prod_afm_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-AFM-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider = azurerm.prod

  key_vault_id = data.azurerm_key_vault.kv_afm_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.prod_afm_tls_cert_service_conn.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}
