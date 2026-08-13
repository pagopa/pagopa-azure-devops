# github_application_pipeline

Reusable Azure DevOps module for GitHub-backed application pipelines.

It creates:
- one GitHub service connection per enabled environment
- `code_review`, `deploy`, and `generic` pipelines
- optional queue authorizations

## How it works

1. `bootstrap_envs` declares the environments to enable (for example `["dev"]` or `["dev", "prod"]`).
2. For each enabled environment, the module resolves the GitHub PAT:
   - from `github_tokens[env]` if provided
   - otherwise from the Key Vault declared in `environment_secrets[env]`
3. The module creates one GitHub service connection per enabled environment.
4. All pipelines are generated per environment, with optional environment suffixes in names/paths.

### Resolution rule per environment

For every environment listed in `bootstrap_envs`, one of these must be available:
- `github_tokens[env]`
- `environment_secrets[env]` (with a valid Key Vault + secret)

If neither is available for an enabled environment, planning fails.

## Required providers

This module expects aliased `azurerm` providers:
- `azurerm.dev`
- `azurerm.uat`
- `azurerm.prod`

Pass them from the caller with:

```hcl
providers = {
  azurerm.dev  = azurerm.dev
  azurerm.uat  = azurerm.uat
  azurerm.prod = azurerm.prod
}
```

## Main inputs

| Name | Description |
|------|-------------|
| `project_id` | Azure DevOps project ID |
| `github_service_connection_name` | Base name for GitHub service connections |
| `github_token_secret_name` | Secret name containing the PAT |
| `bootstrap_envs` | Environments to instantiate (`dev`,`uat`,`prod`) |
| `environment_secrets` | Per-env Key Vault info for PAT lookup |
| `github_tokens` | Optional per-env PAT override map |
| `append_env_suffix` | Appends env suffix to names/paths |
| `base_variables` | Variables merged into every pipeline |
| `applications` | App-centric definitions (recommended) |
| `pipelines` | Explicit low-level definitions (advanced) |

## Recommended example (`applications`)

```hcl
module "portalpa" {
  source = "../modules/github_application_pipeline"

  providers = {
    azurerm.dev  = azurerm.dev
    azurerm.uat  = azurerm.uat
    azurerm.prod = azurerm.prod
  }

  project_id                     = data.azuredevops_project.project.id
  github_service_connection_name = "centralhub-azure-devops-github"
  github_token_secret_name       = "azure-devops-centralhub-github-token"
  bootstrap_envs                 = ["dev", "prod"]

  environment_secrets = {
    dev = {
      key_vault_name           = "pagopa-d-itn-portalpa-kv"
      key_vault_resource_group = "pagopa-d-itn-portalpa-sec-rg"
    }
    prod = {
      key_vault_name           = "pagopa-p-itn-portalpa-kv"
      key_vault_resource_group = "pagopa-p-itn-portalpa-sec-rg"
    }
  }

  base_variables = {
    cache_version_id = "v1"
    default_branch   = "refs/heads/main"
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
            TEST_SUITE    = "performance"
            VUS           = "50"
            TEST_DURATION = "10m"
          }
        }
        smoke_test = {
          pipeline_name         = "smoke-test-pipeline"
          pipeline_yml_filename = "smoke-test-pipelines.yml"
          variables = {
            TEST_SUITE      = "smoke"
            TARGET_ENV      = "prod"
            RETRY_ON_FAILURE = "true"
          }
        }
      }
    }
  }
}
```

This example creates, for each enabled environment:
- 1 code review pipeline
- 1 deploy pipeline
- 2 generic pipelines

## Outputs

- `github_service_connection_id`: map of service connection IDs by environment
- `github_service_connection_name`: map of service connection names by environment
- `pipeline_kinds`: pipeline kind (`code_review`, `deploy`, `generic`) per generated pipeline key

## Notes

- If `append_env_suffix = true`, the module appends `-<env>` to service connection/pipeline names and adds `\env` to path.
- `github_connection` is always injected in pipeline variables with the environment-specific service connection name.
- `service_connection_ids_authorization` is automatically extended with the created GitHub service connection ID.

## Troubleshooting

- `No valid credentials found` from `azuredevops` provider: set Azure DevOps credentials in your environment before `plan/apply`.
- `Value for undeclared variable` warnings from shared tfvars: declare the variable in the root module or remove it from that tfvars for this stack.
