data "azurerm_key_vault" "domain_kv_dev" {

  provider = azurerm.dev

  resource_group_name = local.dev_mocker_key_vault_resource_group
  name                = local.dev_mocker_key_vault_name
}

#data "azurerm_key_vault" "domain_kv_uat" {
#
#  provider = azurerm.uat
#
#  resource_group_name = local.uat_mocker_key_vault_resource_group
#  name                = local.uat_mocker_key_vault_name
#}
