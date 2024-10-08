resource "azuredevops_project" "project" {
  name               = "pagoPA-projects"
  description        = "This is the DevOps project for pagoPA service projects"
  visibility         = "public"
  version_control    = "Git"
  work_item_template = "Basic"

  depends_on = [module.__azdo__]
}

resource "azuredevops_project_features" "project_features" {
  project_id = azuredevops_project.project.id
  features = {
    "boards"       = "enabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
    "testplans"    = "enabled"
    "artifacts"    = "disabled"
  }
}
