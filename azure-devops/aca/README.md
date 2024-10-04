# aca

<!-- markdownlint-disable -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | <= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.107.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | <= 0.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-ACA-TLS-CERT-SERVICE-CONN"></a> [DEV-ACA-TLS-CERT-SERVICE-CONN](#module\_DEV-ACA-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v9.2.1 |
| <a name="module_PROD-ACA-TLS-CERT-SERVICE-CONN"></a> [PROD-ACA-TLS-CERT-SERVICE-CONN](#module\_PROD-ACA-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v9.2.1 |
| <a name="module_UAT-ACA-TLS-CERT-SERVICE-CONN"></a> [UAT-ACA-TLS-CERT-SERVICE-CONN](#module\_UAT-ACA-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v9.2.1 |
| <a name="module___azdo__"></a> [\_\_azdo\_\_](#module\_\_\_azdo\_\_) | git::https://github.com/pagopa/azuredevops-tf-modules.git | 7e23d73d22e7b37352c25a32cc40f6f42b6569ea |
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | e64f39b63d46e8c05470e30eca873f44a0ab7f1b |
| <a name="module_aca_dev_secrets"></a> [aca\_dev\_secrets](#module\_aca\_dev\_secrets) | ./.terraform/modules/__v3__/key_vault_secrets_query | n/a |
| <a name="module_aca_prod_secrets"></a> [aca\_prod\_secrets](#module\_aca\_prod\_secrets) | ./.terraform/modules/__v3__/key_vault_secrets_query | n/a |
| <a name="module_aca_uat_secrets"></a> [aca\_uat\_secrets](#module\_aca\_uat\_secrets) | ./.terraform/modules/__v3__/key_vault_secrets_query | n/a |
| <a name="module_letsencrypt_dev"></a> [letsencrypt\_dev](#module\_letsencrypt\_dev) | ./.terraform/modules/__v3__/letsencrypt_credential | n/a |
| <a name="module_letsencrypt_prod"></a> [letsencrypt\_prod](#module\_letsencrypt\_prod) | ./.terraform/modules/__v3__/letsencrypt_credential | n/a |
| <a name="module_letsencrypt_uat"></a> [letsencrypt\_uat](#module\_letsencrypt\_uat) | ./.terraform/modules/__v3__/letsencrypt_credential | n/a |
| <a name="module_pagopa-aca-service_code_review"></a> [pagopa-aca-service\_code\_review](#module\_pagopa-aca-service\_code\_review) | ./.terraform/modules/__azdo__/azuredevops_build_definition_code_review | n/a |
| <a name="module_pagopa-aca-service_deploy"></a> [pagopa-aca-service\_deploy](#module\_pagopa-aca-service\_deploy) | ./.terraform/modules/__azdo__/azuredevops_build_definition_deploy | n/a |
| <a name="module_pagopa-aca-tests_soak"></a> [pagopa-aca-tests\_soak](#module\_pagopa-aca-tests\_soak) | ./.terraform/modules/__azdo__/azuredevops_build_definition_generic | n/a |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ./.terraform/modules/__v3__/key_vault_secrets_query | n/a |
| <a name="module_tlscert-weudev-aca-internal-dev-platform-pagopa-it-cert_az"></a> [tlscert-weudev-aca-internal-dev-platform-pagopa-it-cert\_az](#module\_tlscert-weudev-aca-internal-dev-platform-pagopa-it-cert\_az) | ./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated | n/a |
| <a name="module_tlscert-weuprod-aca-internal-prod-platform-pagopa-it-cert_az"></a> [tlscert-weuprod-aca-internal-prod-platform-pagopa-it-cert\_az](#module\_tlscert-weuprod-aca-internal-prod-platform-pagopa-it-cert\_az) | ./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated | n/a |
| <a name="module_tlscert-weuuat-aca-internal-uat-platform-pagopa-it-cert_az"></a> [tlscert-weuuat-aca-internal-uat-platform-pagopa-it-cert\_az](#module\_tlscert-weuuat-aca-internal-uat-platform-pagopa-it-cert\_az) | ./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated | n/a |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azurerm_key_vault_access_policy.DEV-ACA-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.PROD-ACA-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-ACA-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurerm.dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_azurerm.prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_azurerm.uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_github.github_pr](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.github_ro](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.github_rw](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.domain_kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscriptions.dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_ita_service_connection_workload_identity_dev"></a> [acr\_ita\_service\_connection\_workload\_identity\_dev](#input\_acr\_ita\_service\_connection\_workload\_identity\_dev) | The service connection ID for the ITA DEV workload identity in Azure Container Registry | `string` | `""` | no |
| <a name="input_acr_ita_service_connection_workload_identity_prod"></a> [acr\_ita\_service\_connection\_workload\_identity\_prod](#input\_acr\_ita\_service\_connection\_workload\_identity\_prod) | The service connection ID for the ITA PROD workload identity in Azure Container Registry | `string` | `""` | no |
| <a name="input_acr_ita_service_connection_workload_identity_uat"></a> [acr\_ita\_service\_connection\_workload\_identity\_uat](#input\_acr\_ita\_service\_connection\_workload\_identity\_uat) | The service connection ID for the ITA UAT workload identity in Azure Container Registry | `string` | `""` | no |
| <a name="input_acr_weu_service_connection_workload_identity_dev"></a> [acr\_weu\_service\_connection\_workload\_identity\_dev](#input\_acr\_weu\_service\_connection\_workload\_identity\_dev) | The service connection ID for the WEU DEV workload identity in Azure Container Registry | `string` | `""` | no |
| <a name="input_acr_weu_service_connection_workload_identity_prod"></a> [acr\_weu\_service\_connection\_workload\_identity\_prod](#input\_acr\_weu\_service\_connection\_workload\_identity\_prod) | The service connection ID for the WEU PROD workload identity in Azure Container Registry | `string` | `""` | no |
| <a name="input_acr_weu_service_connection_workload_identity_uat"></a> [acr\_weu\_service\_connection\_workload\_identity\_uat](#input\_acr\_weu\_service\_connection\_workload\_identity\_uat) | The service connection ID for the WEU UAT workload identity in Azure Container Registry | `string` | `""` | no |
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_pagopa-aca-service"></a> [pagopa-aca-service](#input\_pagopa-aca-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-aca-service",<br>      "project_name": "pagopa-aca-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-aca-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-aca-tests"></a> [pagopa-aca-tests](#input\_pagopa-aca-tests) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_soak": true,<br>    "name": "soak-test-pipeline"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-aca-tests",<br>    "organization": "pagopa",<br>    "pipeline_yml_filename": "soaktest.yaml",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_service_connection_dev_acr_name"></a> [service\_connection\_dev\_acr\_name](#input\_service\_connection\_dev\_acr\_name) | ACR service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_dev_azurerm_name"></a> [service\_connection\_dev\_azurerm\_name](#input\_service\_connection\_dev\_azurerm\_name) | Azurerm service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_prod_acr_name"></a> [service\_connection\_prod\_acr\_name](#input\_service\_connection\_prod\_acr\_name) | ACR service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_prod_azurerm_name"></a> [service\_connection\_prod\_azurerm\_name](#input\_service\_connection\_prod\_azurerm\_name) | Azurerm service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_uat_acr_name"></a> [service\_connection\_uat\_acr\_name](#input\_service\_connection\_uat\_acr\_name) | ACR service connection UAT name | `string` | n/a | yes |
| <a name="input_service_connection_uat_azurerm_name"></a> [service\_connection\_uat\_azurerm\_name](#input\_service\_connection\_uat\_azurerm\_name) | Azurerm service connection UAT name | `string` | n/a | yes |
| <a name="input_tlscert-weudev-aca-internal-dev-platform-pagopa-it"></a> [tlscert-weudev-aca-internal-dev-platform-pagopa-it](#input\_tlscert-weudev-aca-internal-dev-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weudev.aca.internal",<br>    "dns_zone_name": "dev.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-d-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\DEV",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-d-aca-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-weuprod-aca-internal-prod-platform-pagopa-it"></a> [tlscert-weuprod-aca-internal-prod-platform-pagopa-it](#input\_tlscert-weuprod-aca-internal-prod-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weuprod.aca.internal",<br>    "dns_zone_name": "platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-p-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\PROD",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-p-aca-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-weuuat-aca-internal-uat-platform-pagopa-it"></a> [tlscert-weuuat-aca-internal-uat-platform-pagopa-it](#input\_tlscert-weuuat-aca-internal-uat-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weuuat.aca.internal",<br>    "dns_zone_name": "uat.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-u-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-u-aca-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
