resource "azuredevops_project" "project" {
  name               = "ecommerce-pagoPA-projects"
  description        = "This is the DevOps project for ecommerce pagoPA service projects"
  visibility         = "public"
  version_control    = "Git"
  work_item_template = "Basic"
}

resource "azuredevops_project_features" "project_features" {
  project_id = azuredevops_project.project.id
  features = {
    "boards"       = "disabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
  }
}
