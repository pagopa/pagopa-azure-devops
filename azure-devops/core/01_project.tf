resource "azuredevops_project" "project" {
  name               = "pagoPA-projects"
  description        = "This is the DevOps project for pagoPA service projects"
  visibility         = "public"
  version_control    = "Git"
  work_item_template = "Basic"

  depends_on = [module.__azdo__]
}
