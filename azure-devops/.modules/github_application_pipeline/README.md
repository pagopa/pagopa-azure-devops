# github_application_pipeline

Reusable Azure DevOps module for GitHub-backed application pipelines.

It creates:
- a GitHub service connection backed by a PAT stored in Azure Key Vault
- `code_review`, `deploy`, and `generic` pipelines
- optional queue authorizations for agent pools

---

## Pipeline model

This module supports two configuration styles:

1. `applications` (**recommended**)  
   App-centric, compact, and flag-based (`enable_code_review`, `enable_deploy`).

2. `pipelines` (advanced/legacy)  
   Fully explicit per-pipeline map with `kind`.

You can use only `applications`, or mix both if needed.

---

## Supported pipeline kinds

| Kind | Purpose |
|------|---------|
| `code_review` | PR validation pipeline |
| `deploy` | Application deployment pipeline |
| `generic` | Custom YAML pipeline (`pipeline_name` + `pipeline_yml_filename`) |

---

## Requirements

- Azure DevOps project ID
- GitHub PAT stored in Azure Key Vault
- GitHub service connection name to create in Azure DevOps

PAT minimum scopes:
- `repo`
- `admin:repo_hook`

---

## Main inputs

| Name | Description |
|------|-------------|
| `project_id` | Azure DevOps project ID |
| `github_service_connection_name` | Name of the GitHub service connection to create |
| `github_token_key_vault_name` | Key Vault containing the PAT |
| `github_token_key_vault_resource_group` | Resource group containing the Key Vault |
| `github_token_secret_name` | Secret name holding the PAT |
| `base_variables` | Variables merged into every pipeline |
| `applications` | App-centric pipeline definitions (recommended) |
| `pipelines` | Explicit pipeline definitions by kind (advanced) |

---

## Recommended usage (`applications`)

```hcl
module "portalpa" {
  source = "../.modules/github_application_pipeline"

  providers = {
    azurerm = azurerm.prod
  }

  project_id                            = data.azuredevops_project.project.id
  github_service_connection_name        = "centralhub-azure-devops-github"
  github_token_key_vault_name           = "pagopa-p-itn-portalpa-kv"
  github_token_key_vault_resource_group = "pagopa-p-itn-portalpa-sec-rg"
  github_token_secret_name              = "azure-devops-centralhub-github-token"

  base_variables = {
    cache_version_id  = "v1"
    default_branch    = "refs/heads/main"
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    github_connection = "centralhub-azure-devops-github"
  }

  applications = {
    portalpa = {
      repository = {
        organization    = "pagopa"
        name            = "pagopa-payments-department-centralhub"
        branch_name     = "refs/heads/main"
        pipelines_path  = ".devops"
        yml_prefix_name = null
      }

      path            = "centralhub\\pagopa-portalpa"
      pipeline_prefix = "pagopa-portalpa"

      enable_code_review = true
      enable_deploy      = true

      code_review = {
        variables = {
          danger_github_api_token = "skip"
        }
      }

      deploy = {
        variables = {
          image_repository = "pagopa-portal"
        }
      }

      generic = {
        perf_test = {
          pipeline_name         = "performance-test-pipeline"
          pipeline_yml_filename = "performance-test-pipelines.yml"
          variables = {
            TEST_SUITE = "perf"
          }
        }

        smoke_test = {
          pipeline_name         = "smoke-test-pipeline"
          pipeline_yml_filename = "smoke-test-pipelines.yml"
          variables = {
            TEST_SUITE = "smoke"
          }
        }
      }
    }
  }
}
```

This single app definition creates:
- 1 code review pipeline (`portalpa_code_review`)
- 1 deploy pipeline (`portalpa_deploy`)
- 2 generic pipelines (`portalpa_perf_test`, `portalpa_smoke_test`)

---

## Notes

- The GitHub service connection is created before pipeline creation.
- `base_variables` are merged into every generated pipeline.
- For each pipeline, `service_connection_ids_authorization` is automatically prefixed with the created GitHub service connection ID.
- `queue_ids_to_authorize` is optional and can be set per pipeline/app section.
