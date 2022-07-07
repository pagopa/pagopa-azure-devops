output "service_endpoint_azure_devops_acr_aks_dev_id" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_dev.id
}

output "service_endpoint_azure_devops_acr_aks_dev_name" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_dev.service_endpoint_name
}

output "service_endpoint_azure_devops_github_rw_name" {
  value = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
}

output "service_endpoint_azure_devops_github_pr_id" {
  value = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
}

output "service_endpoint_azure_devops_github_ro_id" {
  value = azuredevops_serviceendpoint_github.azure-devops-github-ro.id
}

output "service_endpoint_azure_devops_github_rw_id" {
  value = azuredevops_serviceendpoint_github.azure-devops-github-rw.id
}

output "service_endpoint_azure_dev_id" {
  value = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id
}

