resource "azuredevops_environment" "environments_nodo" {
  for_each = toset(var.pipeline_environments_extra)

  project_id = data.azuredevops_project.project.id
  name       = each.key
}
