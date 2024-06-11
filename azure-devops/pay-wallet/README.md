# wallet

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
| <a name="module_DEV-WALLET-TLS-CERT-SERVICE-CONN"></a> [DEV-WALLET-TLS-CERT-SERVICE-CONN](#module\_DEV-WALLET-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_UAT-WALLET-TLS-CERT-SERVICE-CONN"></a> [UAT-WALLET-TLS-CERT-SERVICE-CONN](#module\_UAT-WALLET-TLS-CERT-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_letsencrypt_dev"></a> [letsencrypt\_dev](#module\_letsencrypt\_dev) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v7.30.0 |
| <a name="module_letsencrypt_uat"></a> [letsencrypt\_uat](#module\_letsencrypt\_uat) | git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential | v7.30.0 |
| <a name="module_pagopa-payment-wallet-event-dispatcher-service_code_review"></a> [pagopa-payment-wallet-event-dispatcher-service\_code\_review](#module\_pagopa-payment-wallet-event-dispatcher-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-payment-wallet-event-dispatcher-service_deploy"></a> [pagopa-payment-wallet-event-dispatcher-service\_deploy](#module\_pagopa-payment-wallet-event-dispatcher-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-wallet-service_code_review"></a> [pagopa-wallet-service\_code\_review](#module\_pagopa-wallet-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-wallet-service_deploy"></a> [pagopa-wallet-service\_deploy](#module\_pagopa-wallet-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_tlscert-itndev-pay-wallet-internal-dev-platform-pagopa-it-cert_az"></a> [tlscert-itndev-pay-wallet-internal-dev-platform-pagopa-it-cert\_az](#module\_tlscert-itndev-pay-wallet-internal-dev-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v5.0.0 |
| <a name="module_tlscert-itnuat-pay-wallet-internal-uat-platform-pagopa-it-cert_az"></a> [tlscert-itnuat-pay-wallet-internal-uat-platform-pagopa-it-cert\_az](#module\_tlscert-itnuat-pay-wallet-internal-uat-platform-pagopa-it-cert\_az) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert_federated | v5.0.0 |
| <a name="module_wallet_dev_secrets"></a> [wallet\_dev\_secrets](#module\_wallet\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_wallet_uat_secrets"></a> [wallet\_uat\_secrets](#module\_wallet\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azurerm_key_vault_access_policy.DEV-WALLET-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.UAT-WALLET-TLS-CERT-SERVICE-CONN_kv_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azuredevops_serviceendpoint_azurecr.dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurerm.dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_azurerm.uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_github.github_pr](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.github_ro](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.github_rw](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.domain_kv_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subscriptions.dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_pagopa-payment-wallet-event-dispatcher-service"></a> [pagopa-payment-wallet-event-dispatcher-service](#input\_pagopa-payment-wallet-event-dispatcher-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-payment-wallet-event-dispatcher-service",<br>      "project_name": "pagopa-payment-wallet-event-dispatcher-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-payment-wallet-event-dispatcher-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "pay-wallet"<br>  }<br>}</pre> | no |
| <a name="input_pagopa-wallet-service"></a> [pagopa-wallet-service](#input\_pagopa-wallet-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-wallet-service",<br>      "project_name": "pagopa-wallet-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-wallet-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "pay-wallet"<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_service_connection_dev_acr_name"></a> [service\_connection\_dev\_acr\_name](#input\_service\_connection\_dev\_acr\_name) | ACR service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_dev_azurerm_name"></a> [service\_connection\_dev\_azurerm\_name](#input\_service\_connection\_dev\_azurerm\_name) | Azurerm service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_prod_acr_name"></a> [service\_connection\_prod\_acr\_name](#input\_service\_connection\_prod\_acr\_name) | ACR service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_prod_azurerm_name"></a> [service\_connection\_prod\_azurerm\_name](#input\_service\_connection\_prod\_azurerm\_name) | Azurerm service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_uat_acr_name"></a> [service\_connection\_uat\_acr\_name](#input\_service\_connection\_uat\_acr\_name) | ACR service connection UAT name | `string` | n/a | yes |
| <a name="input_service_connection_uat_azurerm_name"></a> [service\_connection\_uat\_azurerm\_name](#input\_service\_connection\_uat\_azurerm\_name) | Azurerm service connection UAT name | `string` | n/a | yes |
| <a name="input_tlscert-itndev-pay-wallet-internal-dev-platform-pagopa-it"></a> [tlscert-itndev-pay-wallet-internal-dev-platform-pagopa-it](#input\_tlscert-itndev-pay-wallet-internal-dev-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "itndev.pay-wallet.internal",<br>    "dns_zone_name": "dev.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-d-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\DEV",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-d-pay-wallet-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_tlscert-itnuat-pay-wallet-internal-uat-platform-pagopa-it"></a> [tlscert-itnuat-pay-wallet-internal-uat-platform-pagopa-it](#input\_tlscert-itnuat-pay-wallet-internal-uat-platform-pagopa-it) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "dns_record_name": "itnuat.pay-wallet.internal",<br>    "dns_zone_name": "uat.platform.pagopa.it",<br>    "dns_zone_resource_group": "pagopa-u-vnet-rg",<br>    "enable_tls_cert": true,<br>    "path": "TLS-Certificates\\UAT",<br>    "variables": {<br>      "CERT_NAME_EXPIRE_SECONDS": "2592000",<br>      "KEY_VAULT_NAME": "pagopa-u-pay-wallet-kv"<br>    },<br>    "variables_secret": {}<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/master",<br>    "name": "le-azure-acme-tiny",<br>    "organization": "pagopa",<br>    "pipelines_path": "."<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
