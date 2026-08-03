#
# GITHUB
#
# Dedicated service connection for the QA domain, owned by the QA bot.
# Uses a single PAT (stored in pagopa-u-itn-qa-kv) with all required grant 
# (repo, admin:repo_hook) for all QA pipelines, instead of the shared org-level connections.
#
resource "azuredevops_serviceendpoint_github" "github_qa" {
  depends_on = [data.azuredevops_project.project]

  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.qa_github_connection_name

  auth_personal {
    personal_access_token = module.qa_github_token.values["azure-devops-qa-github-token"].value
  }

  lifecycle {
    ignore_changes = [description, authorization]
  }
}

#
# AZURERM
#
data "azuredevops_serviceendpoint_azurerm" "dev" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_dev_azurerm_name
}

data "azuredevops_serviceendpoint_azurerm" "uat" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_uat_azurerm_name
}

data "azuredevops_serviceendpoint_azurerm" "prod" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_prod_azurerm_name
}
