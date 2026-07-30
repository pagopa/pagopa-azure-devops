#
# Variable groups consumed by the TAS (Test Automation Service) pipelines.
#
# We create one variable group per environment (dev/uat/prod) so that each
# pipeline run consumes the PAT scoped to the target environment, and the
# secret never crosses environment boundaries. The TAS template
# (`tas-integration-tests.yml`) accepts a `secretsGroup` parameter so the
# consumer pipeline picks the right group at runtime.
#
# Naming: `tas-integration-secrets-<env>` — `<env>` aligned with the
# pipeline's `environment` parameter (dev|uat|prod).
#

resource "azuredevops_variable_group" "tas_integration_secrets_dev" {
  project_id   = data.azuredevops_project.project.id
  name         = "tas-integration-secrets-dev"
  description  = "GitHub PAT used by TAS integration tests (DEV)"
  allow_access = true

  variable {
    name         = "INTEGRATION_TEST_PAT"
    secret_value = module.qa_dev_secrets.values[local.tas_integration_pat_secret_name].value
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "tas_integration_secrets_uat" {
  project_id   = data.azuredevops_project.project.id
  name         = "tas-integration-secrets-uat"
  description  = "GitHub PAT used by TAS integration tests (UAT)"
  allow_access = true

  variable {
    name         = "INTEGRATION_TEST_PAT"
    secret_value = module.qa_uat_secrets.values[local.tas_integration_pat_secret_name].value
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "tas_integration_secrets_prod" {
  project_id   = data.azuredevops_project.project.id
  name         = "tas-integration-secrets-prod"
  description  = "GitHub PAT used by TAS integration tests (PROD)"
  allow_access = true

  variable {
    name         = "INTEGRATION_TEST_PAT"
    secret_value = module.qa_prod_secrets.values[local.tas_integration_pat_secret_name].value
    is_secret    = true
  }
}
