data "azurerm_subscriptions" "dev" {
  display_name_prefix = local.dev_subscription_name
}

data "azurerm_subscriptions" "uat" {
  display_name_prefix = local.uat_subscription_name
}

data "azurerm_subscriptions" "prod" {
  display_name_prefix = local.prod_subscription_name
}

data "azuredevops_agent_queue" "dev_linux" {
  project_id = data.azuredevops_project.project.id
  name       = "pagopa-dev-linux"
}

data "azuredevops_agent_queue" "uat_linux" {
  project_id = data.azuredevops_project.project.id
  name       = "pagopa-uat-linux"
}

data "azuredevops_agent_queue" "prod_linux" {
  project_id = data.azuredevops_project.project.id
  name       = "pagopa-prod-linux"
}
