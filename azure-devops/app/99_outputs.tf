output "service_endpoint_azure_devops_acr_aks_dev_id" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_dev.id
}
output "service_endpoint_azure_devops_acr_aks_uat_id" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_uat.id
}
output "service_endpoint_azure_devops_acr_aks_prod_id" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_prod.id
}

output "service_endpoint_azure_devops_acr_aks_dev_name" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_dev.service_endpoint_name
}
output "service_endpoint_azure_devops_acr_aks_uat_name" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_uat.service_endpoint_name
}
output "service_endpoint_azure_devops_acr_aks_prod_name" {
  value = azuredevops_serviceendpoint_azurecr.acr_aks_prod.service_endpoint_name
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
output "service_endpoint_azure_uat_id" {
  value = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id
}
output "service_endpoint_azure_prod_id" {
  value = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id
}

output "service_endpoint_azure_dev_name" {
  value = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
}
output "service_endpoint_azure_uat_name" {
  value = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
}
output "service_endpoint_azure_prod_name" {
  value = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
}

