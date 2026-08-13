output "github_service_connection_id" {
  value       = { for env, sc in azuredevops_serviceendpoint_github.this : env => sc.id }
  description = "GitHub service connection IDs by environment"
}

output "github_service_connection_name" {
  value       = { for env, sc in azuredevops_serviceendpoint_github.this : env => sc.service_endpoint_name }
  description = "GitHub service connection names by environment"
}

output "pipeline_kinds" {
  value = {
    code_review = keys(local.code_review_pipelines)
    deploy      = keys(local.deploy_pipelines)
    generic     = keys(local.generic_pipelines)
  }
  description = "Pipeline names created by kind"
}
