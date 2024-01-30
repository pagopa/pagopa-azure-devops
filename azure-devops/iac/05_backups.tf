module "apim_backup" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v5.5.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.apim_backup.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = "backups"
  pipeline_name_prefix         = "backup-apim"

  ci_trigger_use_yaml = false

  variables = {
    apim_name                 = "pagopa-p-apim"
    apim_rg                   = "pagopa-p-api-rg"
    storage_account_name      = "pagopapbackupstorage"
    backup_name               = "apim-backup"
    storage_account_container = "apim"
    storage_account_rg        = "pagopa-p-data-rg"
  }

  variables_secret = {}

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]

  schedules = {
    days_to_build              = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    schedule_only_with_changes = false
    start_hours                = 7
    start_minutes              = 10
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["main"]
      exclude = []
    }
  }
}
