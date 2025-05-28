# Certificate pipeline action group
data "azurerm_monitor_action_group" "certificate_pipeline_status_dev" {
  provider = azurerm.dev

  resource_group_name = local.dev_monitor_rg
  name                = local.dev_cert_diff_pipeline_status_name
}

data "azurerm_monitor_action_group" "certificate_pipeline_status_uat" {
  provider = azurerm.uat

  resource_group_name = local.uat_monitor_rg
  name                = local.uat_cert_diff_pipeline_status_name
}
