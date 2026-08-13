output "github_service_connection_id" {
  value       = azuredevops_serviceendpoint_github.this.id
  description = "GitHub service connection ID"
}

output "github_service_connection_name" {
  value       = azuredevops_serviceendpoint_github.this.service_endpoint_name
  description = "GitHub service connection name"
}

output "pipeline_kinds" {
  value = {
    code_review = keys(local.code_review_pipelines)
    deploy      = keys(local.deploy_pipelines)
    generic     = keys(local.generic_pipelines)
  }
  description = "Pipeline names created by kind"
}
