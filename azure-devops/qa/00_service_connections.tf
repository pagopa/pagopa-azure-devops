#
# GitHub service connections (already provisioned in the AzDO project).
#
# `github_ro` is enough for TAS pipelines: ADO needs it to read the YAML files
# of the pipeline definitions and to checkout the remote `tas` template
# referenced via `resources.repositories` in the pipeline YAML.
#
data "azuredevops_serviceendpoint_github" "github_ro" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "io-azure-devops-github-ro"
}
