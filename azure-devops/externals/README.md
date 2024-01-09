<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | ~> 0.10.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.85.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-EXTERNALS-TLS-CERT-SERVICE-CONN"></a> [DEV-EXTERNALS-TLS-CERT-SERVICE-CONN](#module\_DEV-EXTERNALS-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.1.5 |
| <a name="module_PROD-EXTERNALS-TLS-CERT-SERVICE-CONN"></a> [PROD-EXTERNALS-TLS-CERT-SERVICE-CONN](#module\_PROD-EXTERNALS-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.1.5 |
| <a name="module_UAT-EXTERNALS-TLS-CERT-SERVICE-CONN"></a> [UAT-EXTERNALS-TLS-CERT-SERVICE-CONN](#module\_UAT-EXTERNALS-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.1.5 |
| <a name="module_pagopa-debt-position_dev_secrets"></a> [pagopa-debt-position\_dev\_secrets](#module\_pagopa-debt-position\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_pagopa-debt-position_uat_secrets"></a> [pagopa-debt-position\_uat\_secrets](#module\_pagopa-debt-position\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_pagopa-node-forwarder_dev_secrets"></a> [pagopa-node-forwarder\_dev\_secrets](#module\_pagopa-node-forwarder\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_pagopa-node-forwarder_uat_secrets"></a> [pagopa-node-forwarder\_uat\_secrets](#module\_pagopa-node-forwarder\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_tlscert-prod-wfesp-dr-pagopa-gov-it-cert_az"></a> [tlscert-prod-wfesp-dr-pagopa-gov-it-cert\_az](#module\_tlscert-prod-wfesp-dr-pagopa-gov-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v4.1.4 |
| <a name="module_tlscert-prod-wfesp-pagopa-gov-it-cert_az"></a> [tlscert-prod-wfesp-pagopa-gov-it-cert\_az](#module\_tlscert-prod-wfesp-pagopa-gov-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v4.1.4 |
| <a name="module_tlscert-prod-wisp2-pagopa-gov-it-cert_az"></a> [tlscert-prod-wisp2-pagopa-gov-it-cert\_az](#module\_tlscert-prod-wisp2-pagopa-gov-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v4.1.4 |
| <a name="module_tlscert-uat-uat-wisp2-gov-pagopa-it-cert_az"></a> [tlscert-uat-uat-wisp2-gov-pagopa-it-cert\_az](#module\_tlscert-uat-uat-wisp2-gov-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v4.1.4 |
| <a name="module_tlscert-uat-wfesp-test-gov-pagopa-it-cert_az"></a> [tlscert-uat-wfesp-test-gov-pagopa-it-cert\_az](#module\_tlscert-uat-wfesp-test-gov-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v4.1.4 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.DEV-EXTERNALS-TLS-CERT-SERVICE-CONN_kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.PROD-EXTERNALS-TLS-CERT-SERVICE-CONN_kv_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-EXTERNALS-TLS-CERT-SERVICE-CONN_kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azuredevops_serviceendpoint_github.azure-devops-github-pr](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.azure-devops-github-ro](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.azure-devops-github-rw](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.kv_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscriptions.dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_project_name_prefix"></a> [project\_name\_prefix](#input\_project\_name\_prefix) | Project name prefix (e.g. userregistry) | `string` | n/a | yes |
| <a name="input_tlscert-prod-wfesp-dr-pagopa-gov-it"></a> [tlscert-prod-wfesp-dr-pagopa-gov-it](#input\_tlscert-prod-wfesp-dr-pagopa-gov-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "wfesp.dr",<br>    "dns_zone_name": "pagopa.gov.it",<br>    "dns_zone_resource_group": "pagopaorg-rg-prod",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\PROD",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-p-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-prod-wfesp-pagopa-gov-it"></a> [tlscert-prod-wfesp-pagopa-gov-it](#input\_tlscert-prod-wfesp-pagopa-gov-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "wfesp",<br>    "dns_zone_name": "pagopa.gov.it",<br>    "dns_zone_resource_group": "pagopaorg-rg-prod",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\PROD",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-p-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-prod-wisp2-pagopa-gov-it"></a> [tlscert-prod-wisp2-pagopa-gov-it](#input\_tlscert-prod-wisp2-pagopa-gov-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "wisp2",<br>    "dns_zone_name": "pagopa.gov.it",<br>    "dns_zone_resource_group": "pagopaorg-rg-prod",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\PROD",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-p-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-uat-uat-wisp2-gov-pagopa-it"></a> [tlscert-uat-uat-wisp2-gov-pagopa-it](#input\_tlscert-uat-uat-wisp2-gov-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "uat.wisp2",<br>    "dns_zone_name": "pagopa.gov.it",<br>    "dns_zone_resource_group": "pagopaorg-rg-prod",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-u-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-uat-wfesp-test-gov-pagopa-it"></a> [tlscert-uat-wfesp-test-gov-pagopa-it](#input\_tlscert-uat-wfesp-test-gov-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "wfesp.test",<br>    "dns_zone_name": "pagopa.gov.it",<br>    "dns_zone_resource_group": "pagopaorg-rg-prod",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-u-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
