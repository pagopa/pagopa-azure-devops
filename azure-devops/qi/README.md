# qi

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
| <a name="module_DEV-QI-TLS-CERT-SERVICE-CONN"></a> [DEV-QI-TLS-CERT-SERVICE-CONN](#module\_DEV-QI-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.7.0 |
| <a name="module_PROD-QI-TLS-CERT-SERVICE-CONN"></a> [PROD-QI-TLS-CERT-SERVICE-CONN](#module\_PROD-QI-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.7.0 |
| <a name="module_UAT-QI-TLS-CERT-SERVICE-CONN"></a> [UAT-QI-TLS-CERT-SERVICE-CONN](#module\_UAT-QI-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.7.0 |
| <a name="module_letsencrypt_dev"></a> [letsencrypt\_dev](#module\_letsencrypt\_dev) | git::https://github.com/pagopa/azurerm.git//letsencrypt_credential | v3.12.0 |
| <a name="module_letsencrypt_prod"></a> [letsencrypt\_prod](#module\_letsencrypt\_prod) | git::https://github.com/pagopa/azurerm.git//letsencrypt_credential | v3.12.0 |
| <a name="module_letsencrypt_uat"></a> [letsencrypt\_uat](#module\_letsencrypt\_uat) | git::https://github.com/pagopa/azurerm.git//letsencrypt_credential | v3.12.0 |
| <a name="module_qi_dev_secrets"></a> [qi\_dev\_secrets](#module\_qi\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_qi_prod_secrets"></a> [qi\_prod\_secrets](#module\_qi\_prod\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_qi_uat_secrets"></a> [qi\_uat\_secrets](#module\_qi\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_tlscert-weudev-qi-internal-dev-platform-pagopa-it-cert_az"></a> [tlscert-weudev-qi-internal-dev-platform-pagopa-it-cert\_az](#module\_tlscert-weudev-qi-internal-dev-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.7.0 |
| <a name="module_tlscert-weuprod-qi-internal-prod-platform-pagopa-it-cert_az"></a> [tlscert-weuprod-qi-internal-prod-platform-pagopa-it-cert\_az](#module\_tlscert-weuprod-qi-internal-prod-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.7.0 |
| <a name="module_tlscert-weuuat-qi-internal-uat-platform-pagopa-it-cert_az"></a> [tlscert-weuuat-qi-internal-uat-platform-pagopa-it-cert\_az](#module\_tlscert-weuuat-qi-internal-uat-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.7.0 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azurerm_key_vault_access_policy.DEV-QI-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.PROD-QI-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-QI-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azurerm_key_vault.domain_kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [terraform_remote_state.app](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_terraform_remote_state_app"></a> [terraform\_remote\_state\_app](#input\_terraform\_remote\_state\_app) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |
| <a name="input_tlscert-weudev-qi-internal-dev-platform-pagopa-it"></a> [tlscert-weudev-qi-internal-dev-platform-pagopa-it](#input\_tlscert-weudev-qi-internal-dev-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weudev.qi.internal",<br>    "dns_zone_name": "dev.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-d-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\DEV",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-d-qi-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-weuprod-qi-internal-prod-platform-pagopa-it"></a> [tlscert-weuprod-qi-internal-prod-platform-pagopa-it](#input\_tlscert-weuprod-qi-internal-prod-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weuprod.qi.internal",<br>    "dns_zone_name": "platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-p-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\PROD",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-p-qi-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-weuuat-qi-internal-uat-platform-pagopa-it"></a> [tlscert-weuuat-qi-internal-uat-platform-pagopa-it](#input\_tlscert-weuuat-qi-internal-uat-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "weuuat.qi.internal",<br>    "dns_zone_name": "uat.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-u-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-u-qi-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->