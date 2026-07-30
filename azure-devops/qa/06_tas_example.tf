#
# TAS pipelines.
#
# Mirrors the layout already in place on Azure DevOps under `qa\tas\`:
#   - tas-example-ado-orchestrator-async
#   - tas-example-ado-orchestrator-sync
#   - tas-example-ado-raw-dispatch
#   - tas-example-ado-using-template
#
# All four pipelines come from the same repository
# (`pagopa/pagopa-platform-integration-test`) and the only difference is the
# YAML file each one points to. We model them as a single `for_each` over a
# map so that adding a new TAS pipeline is a one-line change.
#
# To add a new TAS pipeline:
#   1. add an entry to `local.tas_pipelines` with the YAML path;
#   2. terraform apply.
#

locals {
  tas_examples_repo = {
    organization = "pagopa"
    name         = "pagopa-platform-integration-test"
    branch_name  = "refs/heads/main"
  }

  # AzDO folder where the Terraform-managed TAS pipelines are placed.
  # We use `qa\tas-example` not `qa\tas` where the manually created TAS
  # pipelines currently live.
  tas_pipelines_path = "\\${local.domain}\\tas-example"

  # key = pipeline display name (also unique TF address)
  # value.yml_path = path of the YAML inside the TAS examples repo
  tas_pipelines = {
    "tas-example-ado-orchestrator-async" = {
      yml_path = "docs/tas/examples/tas-example-ado-orchestrator-async.yml"
    }
    "tas-example-ado-orchestrator-sync" = {
      yml_path = "docs/tas/examples/tas-example-ado-orchestrator-sync.yml"
    }
    "tas-example-ado-raw-dispatch" = {
      yml_path = "docs/tas/examples/tas-example-ado-raw-dispatch.yml"
    }
    "tas-example-ado-using-template" = {
      yml_path = "docs/tas/examples/tas-example-ado-using-template.yml"
    }
  }
}

resource "azuredevops_build_definition" "tas" {
  for_each = local.tas_pipelines

  project_id = data.azuredevops_project.project.id
  name       = each.key
  path       = local.tas_pipelines_path

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "${local.tas_examples_repo.organization}/${local.tas_examples_repo.name}"
    branch_name           = local.tas_examples_repo.branch_name
    yml_path              = each.value.yml_path
    service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.service_endpoint_id
  }
}

#
# Authorize the GitHub service connection for every TAS pipeline.
# Required so that each pipeline can clone the `tas` remote template repo
# referenced via `resources.repositories` at runtime.
#
resource "azuredevops_pipeline_authorization" "tas_github" {
  for_each = local.tas_pipelines

  project_id  = data.azuredevops_project.project.id
  resource_id = data.azuredevops_serviceendpoint_github.github_ro.service_endpoint_id
  type        = "endpoint"
  pipeline_id = azuredevops_build_definition.tas[each.key].id
}
