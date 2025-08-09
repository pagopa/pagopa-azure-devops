#
# ⛩ Service connection 2 🔐 KV@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED" {
 depends_on = [data.azuredevops_project.project]
  # source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v9.2.1"
  source = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"

 providers = {
   azurerm = azurerm.dev
 }

 project_id = data.azuredevops_project.project.id
 #tfsec:ignore:general-secrets-no-plaintext-exposure
 name              = "${local.prefix}-${local.domain}-d-azdo-EXTERNALS-TLS-CERT-kv-policy"
 tenant_id         = data.azurerm_client_config.current.tenant_id
 subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
 subscription_name = var.dev_subscription_name

 location            = var.location
 resource_group_name = local.dev_key_vault_resource_group

}

data "azurerm_key_vault" "kv_dev" {
 provider            = azurerm.dev
 name                = local.dev_key_vault_name
 resource_group_name = local.dev_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED_kv_dev" {
 provider = azurerm.dev

 key_vault_id = data.azurerm_key_vault.kv_dev.id
 tenant_id    = data.azurerm_client_config.current.tenant_id
 object_id    = module.DEV-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED.service_principal_object_id

 certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV@UAT 🟨
#
#tfsec:ignore:GEN003
module "UAT-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED" {
 depends_on = [data.azuredevops_project.project]
  # source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v9.2.1"
    source = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"

 providers = {
   azurerm = azurerm.uat
 }

 project_id = data.azuredevops_project.project.id
 #tfsec:ignore:general-secrets-no-plaintext-exposure
 name              = "${local.prefix}-${local.domain}-u-azdo-EXTERNALS-TLS-CERT-kv-policy"
 tenant_id         = data.azurerm_client_config.current.tenant_id
 subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
 subscription_name = var.uat_subscription_name


 location            = var.location
 resource_group_name = local.uat_key_vault_resource_group
}

data "azurerm_key_vault" "kv_uat" {
 provider            = azurerm.uat
 name                = local.uat_key_vault_name
 resource_group_name = local.uat_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED_kv_uat" {
 provider     = azurerm.uat
 key_vault_id = data.azurerm_key_vault.kv_uat.id
 tenant_id    = data.azurerm_client_config.current.tenant_id
 object_id    = module.UAT-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED.service_principal_object_id

 certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV@PROD 🛑
#
#tfsec:ignore:GEN003
module "PROD-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED" {
 depends_on = [data.azuredevops_project.project]
  # source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v9.2.1"
    source = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"

 providers = {
   azurerm = azurerm.prod
 }

 project_id = data.azuredevops_project.project.id
 #tfsec:ignore:general-secrets-no-plaintext-exposure
 name              = "${local.prefix}-${local.domain}-p-azdo-EXTERNALS-TLS-CERT-kv-policy"
 tenant_id         = data.azurerm_client_config.current.tenant_id
 subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
 subscription_name = var.prod_subscription_name

 location            = var.location
 resource_group_name = local.prod_key_vault_resource_group
}

data "azurerm_key_vault" "kv_prod" {
 provider            = azurerm.prod
 name                = local.prod_key_vault_name
 resource_group_name = local.prod_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED_kv_prod" {
 provider     = azurerm.prod
 key_vault_id = data.azurerm_key_vault.kv_prod.id
 tenant_id    = data.azurerm_client_config.current.tenant_id
 object_id    = module.PROD-EXTERNALS-TLS-CERT-SERVICE-CONN-FEDERATED.service_principal_object_id

 certificate_permissions = ["Get", "Import"]
}
