data "azurerm_key_vault" "domain_kv_dev" {

  provider = azurerm.dev

  resource_group_name = local.dev_selfcare_key_vault_resource_group
  name                = local.dev_selfcare_key_vault_name
}


data "azurerm_key_vault" "domain_kv_prod" {

  provider = azurerm.prod

  resource_group_name = local.prod_selfcare_key_vault_resource_group
  name                = local.prod_selfcare_key_vault_name
}
