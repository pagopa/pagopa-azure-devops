<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >= 0.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.98.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | 0.2.0 |
| <a name="provider_azurerm.dev"></a> [azurerm.dev](#provider\_azurerm.dev) | 2.98.0 |
| <a name="provider_azurerm.prod"></a> [azurerm.prod](#provider\_azurerm.prod) | 2.98.0 |
| <a name="provider_azurerm.uat"></a> [azurerm.uat](#provider\_azurerm.uat) | 2.98.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-TLS-CERT-SERVICE-CONN"></a> [DEV-TLS-CERT-SERVICE-CONN](#module\_DEV-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.0.5 |
| <a name="module_PROD-TLS-CERT-SERVICE-CONN"></a> [PROD-TLS-CERT-SERVICE-CONN](#module\_PROD-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.0.5 |
| <a name="module_UAT-TLS-CERT-SERVICE-CONN"></a> [UAT-TLS-CERT-SERVICE-CONN](#module\_UAT-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited | v2.0.5 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.5 |
| <a name="module_tlscert-dev-api-dev-product-pagopa-it-cert_az"></a> [tlscert-dev-api-dev-product-pagopa-it-cert\_az](#module\_tlscert-dev-api-dev-product-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.0.5 |
| <a name="module_tlscert-prod-api-prod-product-pagopa-it-cert_az"></a> [tlscert-prod-api-prod-product-pagopa-it-cert\_az](#module\_tlscert-prod-api-prod-product-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.0.5 |
| <a name="module_tlscert-uat-api-uat-product-pagopa-it-cert_az"></a> [tlscert-uat-api-uat-product-pagopa-it-cert\_az](#module\_tlscert-uat-api-uat-product-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert | v2.0.5 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project) | resource |
| [azuredevops_project_features.project_features](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project_features) | resource |
| [azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-pr](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-ro](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azurerm_key_vault_access_policy.DEV-TLS-CERT-SERVICE-CONN_kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.PROD-TLS-CERT-SERVICE-CONN_kv_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-TLS-CERT-SERVICE-CONN_kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault.kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.kv_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name_prefix"></a> [project\_name\_prefix](#input\_project\_name\_prefix) | Project name prefix (e.g. userregistry) | `string` | n/a | yes |
| <a name="input_tlscert-dev-api-dev-product-pagopa-it"></a> [tlscert-dev-api-dev-product-pagopa-it](#input\_tlscert-dev-api-dev-product-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "api",<br>    "dns_zone_name": "dev.product.pagopa.it",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\DEV",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-prod-api-prod-product-pagopa-it"></a> [tlscert-prod-api-prod-product-pagopa-it](#input\_tlscert-prod-api-prod-product-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "api",<br>    "dns_zone_name": "product.pagopa.it",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\PROD",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-uat-api-uat-product-pagopa-it"></a> [tlscert-uat-api-uat-product-pagopa-it](#input\_tlscert-uat-api-uat-product-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "api",<br>    "dns_zone_name": "uat.product.pagopa.it",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
