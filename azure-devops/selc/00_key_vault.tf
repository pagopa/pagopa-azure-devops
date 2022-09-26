data "azurerm_key_vault" "domain_kv_dev" {

  provider = azurerm.dev

  resource_group_name = local.dev_selc_key_vault_resource_group
  name                = local.dev_selc_key_vault_name
}
