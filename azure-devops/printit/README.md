# printit

<!-- markdownlint-disable -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | <= 1.1.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.107.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | <= 3.2.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | <= 0.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
<<<<<<< HEAD
| <a name="module_DEV-PRINTIT-TLS-CERT-SERVICE-CONN"></a> [DEV-PRINTIT-TLS-CERT-SERVICE-CONN](#module\_DEV-PRINTIT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v9.0.0 |
| <a name="module_PROD-PRINTIT-TLS-CERT-SERVICE-CONN"></a> [PROD-PRINTIT-TLS-CERT-SERVICE-CONN](#module\_PROD-PRINTIT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v9.0.0 |
| <a name="module_UAT-PRINTIT-TLS-CERT-SERVICE-CONN"></a> [UAT-PRINTIT-TLS-CERT-SERVICE-CONN](#module\_UAT-PRINTIT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v9.0.0 |
| <a name="module_general_dev_secrets"></a> [general\_dev\_secrets](#module\_general\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.22.0 |
| <a name="module_general_uat_secrets"></a> [general\_uat\_secrets](#module\_general\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.22.0 |
| <a name="module_letsencrypt_dev"></a> [letsencrypt\_dev](#module\_letsencrypt\_dev) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v8.22.0 |
| <a name="module_letsencrypt_prod"></a> [letsencrypt\_prod](#module\_letsencrypt\_prod) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v8.22.0 |
| <a name="module_letsencrypt_uat"></a> [letsencrypt\_uat](#module\_letsencrypt\_uat) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v8.22.0 |
| <a name="module_pagopa-print-payment-notice-service_performance_test"></a> [pagopa-print-payment-notice-service\_performance\_test](#module\_pagopa-print-payment-notice-service\_performance\_test) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v9.0.0 |
| <a name="module_printit_dev_secrets"></a> [printit\_dev\_secrets](#module\_printit\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.22.0 |
| <a name="module_printit_prod_secrets"></a> [printit\_prod\_secrets](#module\_printit\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.22.0 |
| <a name="module_printit_uat_secrets"></a> [printit\_uat\_secrets](#module\_printit\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.22.0 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.22.0 |
| <a name="module_tlscert-printit-itn-internal-dev-platform-pagopa-it-cert_az"></a> [tlscert-printit-itn-internal-dev-platform-pagopa-it-cert\_az](#module\_tlscert-printit-itn-internal-dev-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v9.0.0 |
| <a name="module_tlscert-printit-itn-internal-prod-platform-pagopa-it-cert_az"></a> [tlscert-printit-itn-internal-prod-platform-pagopa-it-cert\_az](#module\_tlscert-printit-itn-internal-prod-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v9.0.0 |
| <a name="module_tlscert-printit-itn-internal-uat-platform-pagopa-it-cert_az"></a> [tlscert-printit-itn-internal-uat-platform-pagopa-it-cert\_az](#module\_tlscert-printit-itn-internal-uat-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v9.0.0 |
=======
| <a name="module_DEV-PRINTIT-TLS-CERT-SERVICE-CONN"></a> [DEV-PRINTIT-TLS-CERT-SERVICE-CONN](#module\_DEV-PRINTIT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.1.0 |
| <a name="module_UAT-PRINTIT-TLS-CERT-SERVICE-CONN"></a> [UAT-PRINTIT-TLS-CERT-SERVICE-CONN](#module\_UAT-PRINTIT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.1.0 |
| <a name="module_general_dev_secrets"></a> [general\_dev\_secrets](#module\_general\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.67.1 |
| <a name="module_general_prod_secrets"></a> [general\_prod\_secrets](#module\_general\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.67.1 |
| <a name="module_general_uat_secrets"></a> [general\_uat\_secrets](#module\_general\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.67.1 |
| <a name="module_letsencrypt_dev"></a> [letsencrypt\_dev](#module\_letsencrypt\_dev) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v7.1.0 |
| <a name="module_letsencrypt_uat"></a> [letsencrypt\_uat](#module\_letsencrypt\_uat) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v7.1.0 |
| <a name="module_pagopa-print-payment-notice-service_performance_test"></a> [pagopa-print-payment-notice-service\_performance\_test](#module\_pagopa-print-payment-notice-service\_performance\_test) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v4.2.1 |
| <a name="module_printit_dev_secrets"></a> [printit\_dev\_secrets](#module\_printit\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.67.1 |
| <a name="module_printit_prod_secrets"></a> [printit\_prod\_secrets](#module\_printit\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.67.1 |
| <a name="module_printit_uat_secrets"></a> [printit\_uat\_secrets](#module\_printit\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.67.1 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.67.1 |
| <a name="module_tlscert-printit-itn-internal-dev-platform-pagopa-it-cert_az"></a> [tlscert-printit-itn-internal-dev-platform-pagopa-it-cert\_az](#module\_tlscert-printit-itn-internal-dev-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v7.1.0 |
| <a name="module_tlscert-printit-itn-internal-uat-platform-pagopa-it-cert_az"></a> [tlscert-printit-itn-internal-uat-platform-pagopa-it-cert\_az](#module\_tlscert-printit-itn-internal-uat-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v7.1.0 |
>>>>>>> c48ebbf (printit prod secrets)

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azurerm_key_vault_access_policy.DEV-PRINTIT-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.PROD-PRINTIT-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-PRINTIT-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azuredevops_serviceendpoint_azurecr.dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
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
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_pagopa-print-payment-notice-service"></a> [pagopa-print-payment-notice-service](#input\_pagopa-print-payment-notice-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "performance_test": {<br>      "enabled": true,<br>      "name": "performance-test-pipeline",<br>      "pipeline_yml_filename": "performance-test-pipelines.yaml"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-print-payment-notice-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_service_connection_dev_acr_name"></a> [service\_connection\_dev\_acr\_name](#input\_service\_connection\_dev\_acr\_name) | ACR service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_dev_azurerm_name"></a> [service\_connection\_dev\_azurerm\_name](#input\_service\_connection\_dev\_azurerm\_name) | Azurerm service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_prod_acr_name"></a> [service\_connection\_prod\_acr\_name](#input\_service\_connection\_prod\_acr\_name) | ACR service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_prod_azurerm_name"></a> [service\_connection\_prod\_azurerm\_name](#input\_service\_connection\_prod\_azurerm\_name) | Azurerm service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_uat_acr_name"></a> [service\_connection\_uat\_acr\_name](#input\_service\_connection\_uat\_acr\_name) | ACR service connection UAT name | `string` | n/a | yes |
| <a name="input_service_connection_uat_azurerm_name"></a> [service\_connection\_uat\_azurerm\_name](#input\_service\_connection\_uat\_azurerm\_name) | Azurerm service connection UAT name | `string` | n/a | yes |
| <a name="input_tlscert-printit-itn-internal-dev-platform-pagopa-it"></a> [tlscert-printit-itn-internal-dev-platform-pagopa-it](#input\_tlscert-printit-itn-internal-dev-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "printit.itn.internal",<br>    "dns_zone_name": "dev.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-d-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\DEV",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-d-itn-printit-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-printit-itn-internal-prod-platform-pagopa-it"></a> [tlscert-printit-itn-internal-prod-platform-pagopa-it](#input\_tlscert-printit-itn-internal-prod-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "printit.itn.internal",<br>    "dns_zone_name": "platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-p-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\PROD",<br>    "variables": {},<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-printit-itn-internal-uat-platform-pagopa-it"></a> [tlscert-printit-itn-internal-uat-platform-pagopa-it](#input\_tlscert-printit-itn-internal-uat-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "printit.itn.internal",<br>    "dns_zone_name": "uat.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-u-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-u-itn-printit-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
