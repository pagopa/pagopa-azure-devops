# SIA service connection (read-write)
# other docker registry service connection
resource "azuredevops_serviceendpoint_dockerregistry" "sia-registry-dev" {
  depends_on = [azuredevops_project.project]

  project_id            = azuredevops_project.project.id
  service_endpoint_name = "sia-registry-dev"
  docker_registry       = "docker-registry-default.ocp-tst-npaspc.sia.eu"
  docker_username       = "serviceaccount"
  docker_password       = module.secrets.values["DEV-SIA-DOCKER-REGISTRY-PWD"].value
  registry_type         = "Others"
}

resource "azuredevops_serviceendpoint_dockerregistry" "sia-registry-uat" {
  depends_on = [azuredevops_project.project]

  project_id            = azuredevops_project.project.id
  service_endpoint_name = "sia-registry-uat"
  docker_registry       = "docker-registry-default.ocp-tst-npaspc.sia.eu"
  docker_username       = "serviceaccount"
  docker_password       = module.secrets.values["UAT-SIA-DOCKER-REGISTRY-PWD"].value
  registry_type         = "Others"
}

resource "azuredevops_serviceendpoint_dockerregistry" "sia-registry-prod" {
  depends_on = [azuredevops_project.project]

  project_id            = azuredevops_project.project.id
  service_endpoint_name = "sia-registry-prod"
  docker_registry       = "docker-registry-default.ocp-tst-npaspc.sia.eu"
  docker_username       = "serviceaccount"
  docker_password       = module.secrets.values["PROD-SIA-DOCKER-REGISTRY-PWD"].value
  registry_type         = "Others"
}
