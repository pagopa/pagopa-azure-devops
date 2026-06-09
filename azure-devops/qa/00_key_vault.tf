data "azurerm_key_vault" "domain_kv_dev" {
  provider            = azurerm.dev
  name                = local.dev_qa_key_vault_name
  resource_group_name = local.dev_qa_key_vault_resource_group
}

data "azurerm_key_vault" "domain_kv_uat" {
  provider            = azurerm.uat
  name                = local.uat_qa_key_vault_name
  resource_group_name = local.uat_qa_key_vault_resource_group
}

data "azurerm_key_vault" "domain_kv_prod" {
  provider            = azurerm.prod
  name                = local.prod_qa_key_vault_name
  resource_group_name = local.prod_qa_key_vault_resource_group
}

