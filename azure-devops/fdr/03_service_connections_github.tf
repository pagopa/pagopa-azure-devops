#
# 🐙 GITHUB
#

# Github service connection (read-only)
resource "azuredevops_serviceendpoint_github" "azure-devops-github-ro" {
  depends_on = [data.azuredevops_project.project]

  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_github_ro
  auth_personal {
    personal_access_token = module.fdr_dev_secrets.values["azure-devops-github-ro"].value
  }
  lifecycle {
    ignore_changes = [description, authorization]
  }
}

# Github service connection (pull request)
resource "azuredevops_serviceendpoint_github" "azure-devops-github-pr" {
  depends_on = [data.azuredevops_project.project]

  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_github_pr
  auth_personal {
    personal_access_token = module.fdr_dev_secrets.values["azure-devops-github-pr"].value
  }
  lifecycle {
    ignore_changes = [description, authorization]
  }
}

# Github service connection (read-only)
resource "azuredevops_serviceendpoint_github" "azure-devops-github-rw" {
  depends_on = [data.azuredevops_project.project]

  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_github_rw
  auth_personal {
    personal_access_token = module.fdr_dev_secrets.values["azure-devops-github-rw"].value
  }
  lifecycle {
    ignore_changes = [description, authorization]
  }
}



# # Github service connection (read-only)
resource "azuredevops_serviceendpoint_github" "pipelines-azure-devops-github-rw" {
  depends_on = [data.azuredevops_project.project]

  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "pipelines-azure-devops-github-rw"
  auth_personal {
    personal_access_token = module.fdr_dev_secrets.values["azure-devops-github-rw"].value
  }
  lifecycle {
    ignore_changes = [description, authorization]
  }
}
