dev_subscription_name  = "DEV-PAGOPA"
uat_subscription_name  = "UAT-PAGOPA"
prod_subscription_name = "PROD-PAGOPA"

project_name        = "pagoPA-projects"
project_name_prefix = "pagopa"

pipeline_environments = ["DEV", "UAT", "PROD"]

terraform_remote_state_app = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "pagopainfraterraformprod"
  container_name       = "azuredevopsstate"
  key                  = "app-projects.terraform.tfstate"
}