resource "azuredevops_team" "external_team" {
  project_id = azuredevops_project.project.id
  name       = "${local.prefix}-projects-externals-team"
}
