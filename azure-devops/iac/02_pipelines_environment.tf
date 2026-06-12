resource "azuredevops_environment" "environments" {
  for_each = toset(var.pipeline_environments)

  project_id = azuredevops_project.project.id
  name       = each.key
}

resource "azuredevops_environment" "environments_auto" {
  for_each = toset(var.pipeline_environments)

  project_id = azuredevops_project.project.id
  name       = "${each.key}_auto"
}

