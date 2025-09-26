# checkout

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | <= 0.11.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.85.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7.0, < 0.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-CHECKOUT-TLS-CERT-SERVICE-CONN"></a> [DEV-CHECKOUT-TLS-CERT-SERVICE-CONN](#module\_DEV-CHECKOUT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_PROD-CHECKOUT-TLS-CERT-SERVICE-CONN"></a> [PROD-CHECKOUT-TLS-CERT-SERVICE-CONN](#module\_PROD-CHECKOUT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_UAT-CHECKOUT-TLS-CERT-SERVICE-CONN"></a> [UAT-CHECKOUT-TLS-CERT-SERVICE-CONN](#module\_UAT-CHECKOUT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_checkout_dev_secrets"></a> [checkout\_dev\_secrets](#module\_checkout\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.42.3 |
| <a name="module_checkout_prod_secrets"></a> [checkout\_prod\_secrets](#module\_checkout\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.42.3 |
| <a name="module_checkout_uat_secrets"></a> [checkout\_uat\_secrets](#module\_checkout\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.42.3 |
| <a name="module_letsencrypt_dev"></a> [letsencrypt\_dev](#module\_letsencrypt\_dev) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v7.30.0 |
| <a name="module_letsencrypt_prod"></a> [letsencrypt\_prod](#module\_letsencrypt\_prod) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v7.30.0 |
| <a name="module_letsencrypt_uat"></a> [letsencrypt\_uat](#module\_letsencrypt\_uat) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v7.30.0 |
| <a name="module_pagopa-checkout-auth-service_code_review"></a> [pagopa-checkout-auth-service\_code\_review](#module\_pagopa-checkout-auth-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-checkout-auth-service_deploy"></a> [pagopa-checkout-auth-service\_deploy](#module\_pagopa-checkout-auth-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-checkout-fe_code_review"></a> [pagopa-checkout-fe\_code\_review](#module\_pagopa-checkout-fe\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-checkout-fe_deploy"></a> [pagopa-checkout-fe\_deploy](#module\_pagopa-checkout-fe\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-checkout-identity-provider-mock_deploy"></a> [pagopa-checkout-identity-provider-mock\_deploy](#module\_pagopa-checkout-identity-provider-mock\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-checkout-tests_code_review"></a> [pagopa-checkout-tests\_code\_review](#module\_pagopa-checkout-tests\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-functions-checkout_code_review"></a> [pagopa-functions-checkout\_code\_review](#module\_pagopa-functions-checkout\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-functions-checkout_deploy"></a> [pagopa-functions-checkout\_deploy](#module\_pagopa-functions-checkout\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-proxy_code_review"></a> [pagopa-proxy\_code\_review](#module\_pagopa-proxy\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-proxy_deploy"></a> [pagopa-proxy\_deploy](#module\_pagopa-proxy\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_tlscert-weudev-checkout-internal-dev-platform-pagopa-it-cert_az"></a> [tlscert-weudev-checkout-internal-dev-platform-pagopa-it-cert\_az](#module\_tlscert-weudev-checkout-internal-dev-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v5.0.0 |
| <a name="module_tlscert-weuprod-checkout-internal-prod-platform-pagopa-it-cert_az"></a> [tlscert-weuprod-checkout-internal-prod-platform-pagopa-it-cert\_az](#module\_tlscert-weuprod-checkout-internal-prod-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v5.0.0 |
| <a name="module_tlscert-weuuat-checkout-internal-uat-platform-pagopa-it-cert_az"></a> [tlscert-weuuat-checkout-internal-uat-platform-pagopa-it-cert\_az](#module\_tlscert-weuuat-checkout-internal-uat-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azurerm_key_vault_access_policy.DEV-CHECKOUT-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.PROD-CHECKOUT-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-CHECKOUT-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azuredevops_serviceendpoint_azurecr.dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
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
| <a name="input_pagopa-checkout-auth-service"></a> [pagopa-checkout-auth-service](#input\_pagopa-checkout-auth-service) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "enable_code_review": true,<br/>    "enable_deploy": true,<br/>    "sonarcloud": {<br/>      "org": "pagopa",<br/>      "project_key": "pagopa_pagopa-checkout-auth-service",<br/>      "project_name": "pagopa-checkout-auth-service",<br/>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br/>    }<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/main",<br/>    "name": "pagopa-checkout-auth-service",<br/>    "organization": "pagopa",<br/>    "pipelines_path": ".devops",<br/>    "yml_prefix_name": null<br/>  }<br/>}</pre> | no |
| <a name="input_pagopa-checkout-fe"></a> [pagopa-checkout-fe](#input\_pagopa-checkout-fe) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "enable_code_review": true,<br/>    "enable_deploy": true<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/main",<br/>    "name": "pagopa-checkout-fe",<br/>    "organization": "pagopa",<br/>    "pipelines_path": ".devops",<br/>    "yml_prefix_name": "pagopa"<br/>  }<br/>}</pre> | no |
| <a name="input_pagopa-checkout-identity-provider-mock"></a> [pagopa-checkout-identity-provider-mock](#input\_pagopa-checkout-identity-provider-mock) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "enable_code_review": true,<br/>    "enable_deploy": true,<br/>    "sonarcloud": {<br/>      "org": "pagopa",<br/>      "project_key": "pagopa_pagopa-checkout-identity-provider-mock",<br/>      "project_name": "pagopa-checkout-identity-provider-mock",<br/>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br/>    }<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/main",<br/>    "name": "pagopa-checkout-identity-provider-mock",<br/>    "organization": "pagopa",<br/>    "pipelines_path": ".devops",<br/>    "yml_prefix_name": null<br/>  }<br/>}</pre> | no |
| <a name="input_pagopa-checkout-tests"></a> [pagopa-checkout-tests](#input\_pagopa-checkout-tests) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "enable_code_review": true<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/main",<br/>    "name": "pagopa-checkout-tests",<br/>    "organization": "pagopa",<br/>    "pipelines_path": ".devops",<br/>    "yml_prefix_name": null<br/>  }<br/>}</pre> | no |
| <a name="input_pagopa-functions-checkout"></a> [pagopa-functions-checkout](#input\_pagopa-functions-checkout) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "enable_code_review": true,<br/>    "enable_deploy": true<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/main",<br/>    "name": "pagopa-functions-checkout",<br/>    "organization": "pagopa",<br/>    "pipelines_path": ".devops",<br/>    "yml_prefix_name": "pagopa"<br/>  }<br/>}</pre> | no |
| <a name="input_pagopa-proxy"></a> [pagopa-proxy](#input\_pagopa-proxy) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "enable_code_review": true,<br/>    "enable_deploy": true<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/main",<br/>    "name": "io-pagopa-proxy",<br/>    "organization": "pagopa",<br/>    "pipelines_path": ".devops",<br/>    "yml_prefix_name": "pagopa"<br/>  }<br/>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_service_connection_dev_acr_name"></a> [service\_connection\_dev\_acr\_name](#input\_service\_connection\_dev\_acr\_name) | ACR service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_dev_azurerm_name"></a> [service\_connection\_dev\_azurerm\_name](#input\_service\_connection\_dev\_azurerm\_name) | Azurerm service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_prod_acr_name"></a> [service\_connection\_prod\_acr\_name](#input\_service\_connection\_prod\_acr\_name) | ACR service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_prod_azurerm_name"></a> [service\_connection\_prod\_azurerm\_name](#input\_service\_connection\_prod\_azurerm\_name) | Azurerm service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_uat_acr_name"></a> [service\_connection\_uat\_acr\_name](#input\_service\_connection\_uat\_acr\_name) | ACR service connection UAT name | `string` | n/a | yes |
| <a name="input_service_connection_uat_azurerm_name"></a> [service\_connection\_uat\_azurerm\_name](#input\_service\_connection\_uat\_azurerm\_name) | Azurerm service connection UAT name | `string` | n/a | yes |
| <a name="input_tlscert-weudev-checkout-internal-dev-platform-pagopa-it"></a> [tlscert-weudev-checkout-internal-dev-platform-pagopa-it](#input\_tlscert-weudev-checkout-internal-dev-platform-pagopa-it) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "dns_record_name": "weudev.checkout.internal",<br/>    "dns_zone_name": "dev.platform.pagopa.it",<br/>    "dns_zone_resource_group": "pagopa-d-vnet-rg",<br/>    "enable_tls_cert": true,<br/>    "path": "TLS-Certificates\\DEV",<br/>    "variables": {<br/>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br/>      "KEY_VAULT_NAME": "pagopa-d-checkout-kv"<br/>    },<br/>    "variables_secret": {}<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/master",<br/>    "name": "le-azure-acme-tiny",<br/>    "organization": "pagopa",<br/>    "pipelines_path": "."<br/>  }<br/>}</pre> | no |
| <a name="input_tlscert-weuprod-checkout-internal-prod-platform-pagopa-it"></a> [tlscert-weuprod-checkout-internal-prod-platform-pagopa-it](#input\_tlscert-weuprod-checkout-internal-prod-platform-pagopa-it) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "dns_record_name": "weuprod.checkout.internal",<br/>    "dns_zone_name": "platform.pagopa.it",<br/>    "dns_zone_resource_group": "pagopa-p-vnet-rg",<br/>    "enable_tls_cert": true,<br/>    "path": "TLS-Certificates\\PROD",<br/>    "variables": {<br/>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br/>      "KEY_VAULT_NAME": "pagopa-p-checkout-kv"<br/>    },<br/>    "variables_secret": {}<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/master",<br/>    "name": "le-azure-acme-tiny",<br/>    "organization": "pagopa",<br/>    "pipelines_path": "."<br/>  }<br/>}</pre> | no |
| <a name="input_tlscert-weuuat-checkout-internal-uat-platform-pagopa-it"></a> [tlscert-weuuat-checkout-internal-uat-platform-pagopa-it](#input\_tlscert-weuuat-checkout-internal-uat-platform-pagopa-it) | n/a | `map` | <pre>{<br/>  "pipeline": {<br/>    "dns_record_name": "weuuat.checkout.internal",<br/>    "dns_zone_name": "uat.platform.pagopa.it",<br/>    "dns_zone_resource_group": "pagopa-u-vnet-rg",<br/>    "enable_tls_cert": true,<br/>    "path": "TLS-Certificates\\UAT",<br/>    "variables": {<br/>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br/>      "KEY_VAULT_NAME": "pagopa-u-checkout-kv"<br/>    },<br/>    "variables_secret": {}<br/>  },<br/>  "repository": {<br/>    "branch_name": "refs/heads/master",<br/>    "name": "le-azure-acme-tiny",<br/>    "organization": "pagopa",<br/>    "pipelines_path": "."<br/>  }<br/>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
