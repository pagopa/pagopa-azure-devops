# github_application_pipeline

Reusable Azure DevOps module for GitHub-backed application pipelines.

It creates:
- a GitHub service connection backed by a PAT stored in Azure Key Vault
- one or more Azure DevOps pipelines, driven by a `pipelines` map
- optional queue authorizations for hosted agent pools

## Supported pipeline kinds

| Kind | Purpose |
|------|---------|
| `code_review` | PR validation pipeline |
| `deploy` | Application deployment pipeline |
| `generic` | Custom YAML pipeline with an explicit filename |

## Requirements

- Azure DevOps project ID
- a GitHub PAT stored in Key Vault
- a GitHub service connection name to create in Azure DevOps
- a `pipelines` map describing the pipelines to generate

The PAT should have at least:
- `repo`
- `admin:repo_hook`

## Inputs

| Name | Description |
|------|-------------|
| `project_id` | Azure DevOps project ID |
| `github_service_connection_name` | Name of the GitHub service connection to create |
| `github_token_key_vault_name` | Key Vault containing the PAT |
| `github_token_key_vault_resource_group` | Resource group containing the Key Vault |
| `github_token_secret_name` | Secret name holding the PAT |
| `base_variables` | Variables shared by every pipeline |
| `pipelines` | Pipeline definitions grouped by kind |

Each pipeline definition supports:
- `kind`
- `repository`
- `path`
- `pipeline_prefix`
- `pipeline_name`
- `pipeline_yml_filename`
- `pull_request_trigger_use_yaml`
- `variables`
- `variables_secret`
- `service_connection_ids_authorization`
- `queue_ids_to_authorize`

## Example

```hcl
module "portalpa" {
  source = "../modules/github_application_pipeline"

  providers = {
    azurerm = azurerm.prod
  }

  project_id                            = data.azuredevops_project.project.id
  github_service_connection_name        = "centralhub-azure-devops-github"
  github_token_key_vault_name           = "pagopa-p-itn-portalpa-kv"
  github_token_key_vault_resource_group = "pagopa-p-itn-portalpa-sec-rg"
  github_token_secret_name              = "azure-devops-centralhub-github-token"
  base_variables                        = local.centralhub_base_variables
  pipelines                             = local.centralhub_pipelines
}
```

Example pipeline definitions:

```hcl
locals {
  centralhub_pipelines = {
    portalpa_code_review = {
      kind                                 = "code_review"
      repository                           = local.centralhub_repository
      path                                 = "centralhub\\pagopa-portalpa"
      pipeline_prefix                      = "pagopa-portalpa"
      variables                            = { danger_github_api_token = "skip" }
      variables_secret                     = {}
      service_connection_ids_authorization = []
      queue_ids_to_authorize               = []
    }

    portalpa_deploy = {
      kind                                 = "deploy"
      repository                           = local.centralhub_repository
      path                                 = "centralhub\\pagopa-portalpa"
      pipeline_prefix                      = "pagopa-portalpa"
      variables                            = {}
      variables_secret                     = {}
      service_connection_ids_authorization = []
      queue_ids_to_authorize               = []
    }
  }
}
```

## Notes

- The module creates the GitHub service connection before generating pipelines.
- `base_variables` are merged into every pipeline.
- `service_connection_ids_authorization` is merged with the created GitHub service connection.
- `queue_ids_to_authorize` is optional and can be used to grant agent pool access.
