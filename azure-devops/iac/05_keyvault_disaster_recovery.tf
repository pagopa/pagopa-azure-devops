module "keyvault_backup" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.4.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.keyvault_backup.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = "DisasterRecovery"
  pipeline_name                = "keyvault-disaster-recovery"

  ci_trigger_use_yaml = false

  variables = {
    azure_region_dr_location = "northeurope"
  }

  variables_secret = {}

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
  ]

  schedules = {
    days_to_build              = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    schedule_only_with_changes = false
    start_hours                = 5
    start_minutes              = 10
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["main"]
      exclude = []
    }
  }
}