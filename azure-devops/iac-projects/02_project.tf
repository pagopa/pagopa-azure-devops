resource "azuredevops_project" "project" {
  name               = "${var.project_name_prefix}-iac-projects"
  description        = "This is the DevOps project for all ${var.project_name_prefix} IaC pipeline"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Basic"
}

resource "azuredevops_project_features" "project-features" {
  project_id = azuredevops_project.project.id
  features = {
    "pipelines"    = "enabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
  }
}
