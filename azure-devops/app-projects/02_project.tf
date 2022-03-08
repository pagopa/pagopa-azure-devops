resource "azuredevops_project" "project" {
  name               = "${var.project_name_prefix}-projects"
  description        = "This is the DevOps project for ${var.project_name_prefix} service projects"
  visibility         = "public"
  version_control    = "Git"
  work_item_template = "Basic"
}

resource "azuredevops_project_features" "project_features" {
  project_id = azuredevops_project.project.id
  features = {
    "pipelines"    = "enabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
  }
}
