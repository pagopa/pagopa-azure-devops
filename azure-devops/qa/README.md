# qa

Azure DevOps **QA** context: hosts the pipelines that exercise the
**Test Automation Service (TAS)** for the pagoPA platform.

The TAS pipelines are intentionally minimal — they are thin wrappers around
the official ADO template published in
[`pagopa/pagopa-platform-integration-test`](https://github.com/pagopa/pagopa-platform-integration-test/tree/main/docs/tas/examples).
For this reason this context is **much simpler** than the other domain
contexts (e.g. `qi/`, `aca/`, ...): no AKS, ACR, Sonar, TLS or deploy plumbing
is needed.

## Layout

| File | Purpose |
|---|---|
| `99_main.tf` | Terraform + provider blocks. Three `azurerm` aliases (`dev`/`uat`/`prod`) following the same convention as the other contexts. |
| `99_variables.tf` | `domain = "qa"`, KV names per env, input variables. |
| `00_generic.tf` | Subscription data sources. |
| `01_project.tf` | Look up the existing AzDO project (created by `iac/`). |
| `00_key_vault.tf` | Data sources for `pagopa-{d\|u\|p}-qi-kv` (KVs hosting the GitHub PAT). |
| `00_secrets_qa.tf` | Read `integration-test-pat` from each KV via `key_vault_secrets_query`. |
| `00_service_connections.tf` | Look up the existing `io-azure-devops-github-ro` GitHub SC. |
| `02_variable_group_tas.tf` | Three variable groups `tas-integration-secrets-{dev,uat,prod}` carrying `INTEGRATION_TEST_PAT` from the matching KV. |
| `06_tas_example.tf` | Example pipeline `tas-example-ado-using-template` pointing to the published YAML. Template for new TAS pipelines. |

## Per-environment parametrization

The same convention used elsewhere: a single TF apply provisions all three
environments, each represented by an `azurerm` provider alias and a dedicated
KV/secret/variable group. The pipeline picks the correct variable group at
runtime via the template's `secretsGroup` parameter, e.g.:

```yaml
- template: .azuredevops/templates/tas-integration-tests.yml@tas
  parameters:
    environment:  ${{ parameters.environment }}
    secretsGroup: tas-integration-secrets-${{ parameters.environment }}
```

## Prerequisites

Before `terraform apply`:

1. The `INTEGRATION_TEST_PAT` (a GitHub PAT with `public_repo` + `actions:read`
   scopes) must be stored in each environment KV under the secret name
   `integration-test-pat`:
   * `pagopa-d-qi-kv`
   * `pagopa-u-qi-kv`
   * `pagopa-p-qi-kv`
2. The GitHub service connection `io-azure-devops-github-ro` must already
   exist in the AzDO project.
3. The standard `.env/qa_state.tfvars` and `.env/terraform.tfvars` must be in
   place (same pattern as the other contexts).

## How to apply

```sh
cd azure-devops
sh terraform.sh init  qa
sh terraform.sh plan  qa
sh terraform.sh apply qa
```

## Adding a new TAS pipeline

Copy `06_tas_example.tf` to `06_tas_<component>.tf`, then change:

* `resource "azuredevops_build_definition" "<unique_id>"`
* `name`              — pipeline display name
* `yml_path`          — path of the YAML inside the repo
* `repo_id` / `branch_name` — if the YAML lives in a different repo

Remember to update the `azuredevops_pipeline_authorization` accordingly so the
pipeline keeps access to the GitHub service connection.
