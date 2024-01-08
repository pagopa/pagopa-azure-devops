#
# 🐙 GITHUB
#

# Github service connection (read-only)
data "azuredevops_serviceendpoint_github" "azure-devops-github-ro" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_github_ro
}

# Github service connection (pull request)
data "azuredevops_serviceendpoint_github" "azure-devops-github-pr" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_github_pr
}


# Github service connection (read-only)
data "azuredevops_serviceendpoint_github" "azure-devops-github-rw" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_github_rw
}
