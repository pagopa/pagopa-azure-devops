# apiconfig

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >= 0.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.98.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7.0, < 0.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-APPINSIGHTS-SERVICE-CONN"></a> [DEV-APPINSIGHTS-SERVICE-CONN](#module\_DEV-APPINSIGHTS-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.6.5 |
| <a name="module_DEV-RECEIPTS-TLS-CERT-SERVICE-CONN"></a> [DEV-RECEIPTS-TLS-CERT-SERVICE-CONN](#module\_DEV-RECEIPTS-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.6.5 |
| <a name="module_UAT-RECEIPTS-TLS-CERT-SERVICE-CONN"></a> [UAT-RECEIPTS-TLS-CERT-SERVICE-CONN](#module\_UAT-RECEIPTS-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.6.5 |
| <a name="module_letsencrypt_dev"></a> [letsencrypt\_dev](#module\_letsencrypt\_dev) | git::https://github.com/pagopa/azurerm.git//letsencrypt_credential | v3.12.0 |
| <a name="module_letsencrypt_uat"></a> [letsencrypt\_uat](#module\_letsencrypt\_uat) | git::https://github.com/pagopa/azurerm.git//letsencrypt_credential | v2.18.0 |
| <a name="module_pagopa-receipt-pdf-datastore_performance_test"></a> [pagopa-receipt-pdf-datastore\_performance\_test](#module\_pagopa-receipt-pdf-datastore\_performance\_test) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v2.6.3 |
| <a name="module_pagopa-receipt-pdf-service_performance_test"></a> [pagopa-receipt-pdf-service\_performance\_test](#module\_pagopa-receipt-pdf-service\_performance\_test) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v2.6.3 |
| <a name="module_receipts_dev_secrets"></a> [receipts\_dev\_secrets](#module\_receipts\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_receipts_uat_secrets"></a> [receipts\_uat\_secrets](#module\_receipts\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_tlscert-weudev-receipts-internal-dev-platform-pagopa-it-cert_az"></a> [tlscert-weudev-receipts-internal-dev-platform-pagopa-it-cert\_az](#module\_tlscert-weudev-receipts-internal-dev-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.6.5 |
| <a name="module_tlscert-weuuat-receipts-internal-uat-platform-pagopa-it-cert_az"></a> [tlscert-weuuat-receipts-internal-uat-platform-pagopa-it-cert\_az](#module\_tlscert-weuuat-receipts-internal-uat-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.6.5 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azurerm_key_vault_access_policy.DEV-RECEIPTS-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-RECEIPTS-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_role_assignment.appinsights_component_contributor_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azurerm_application_insights.application_insights_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_key_vault.domain_kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [terraform_remote_state.app](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_pagopa-receipt-pdf-datastore"></a> [pagopa-receipt-pdf-datastore](#input\_pagopa-receipt-pdf-datastore) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_deploy": true,<br>    "performance_test": {<br>      "enabled": true,<br>      "name": "performance-test-receipt-pdf-datastore-pipeline",<br>      "pipeline_yml_filename": "performance-test-pipelines.yml"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-receipt-pdf-datastore",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-receipt-pdf-service"></a> [pagopa-receipt-pdf-service](#input\_pagopa-receipt-pdf-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_deploy": true,<br>    "performance_test": {<br>      "enabled": true,<br>      "name": "performance-test-receipt-pdf-service-pipeline",<br>      "pipeline_yml_filename": "performance-test-pipelines.yml"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-receipt-pdf-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_terraform_remote_state_app"></a> [terraform\_remote\_state\_app](#input\_terraform\_remote\_state\_app) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |
| <a name="input_tlscert-weudev-receipts-internal-dev-platform-pagopa-it"></a> [tlscert-weudev-receipts-internal-dev-platform-pagopa-it](#input\_tlscert-weudev-receipts-internal-dev-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weudev.receipts.internal",<br>    "dns_zone_name": "dev.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-d-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\DEV",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-d-receipts-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-weuuat-receipts-internal-uat-platform-pagopa-it"></a> [tlscert-weuuat-receipts-internal-uat-platform-pagopa-it](#input\_tlscert-weuuat-receipts-internal-uat-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weuuat.receipts.internal",<br>    "dns_zone_name": "uat.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-u-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-u-receipts-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
