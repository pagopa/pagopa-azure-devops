<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >= 0.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.98.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecommerce_dev_secrets"></a> [ecommerce\_dev\_secrets](#module\_ecommerce\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_ecommerce_uat_secrets"></a> [ecommerce\_uat\_secrets](#module\_ecommerce\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_pagopa-ecommerce-notifications-service_code_review"></a> [pagopa-ecommerce-notifications-service\_code\_review](#module\_pagopa-ecommerce-notifications-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.2.0 |
| <a name="module_pagopa-ecommerce-notifications-service_deploy"></a> [pagopa-ecommerce-notifications-service\_deploy](#module\_pagopa-ecommerce-notifications-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.2.0 |
| <a name="module_pagopa-ecommerce-payment-methods-service_code_review"></a> [pagopa-ecommerce-payment-methods-service\_code\_review](#module\_pagopa-ecommerce-payment-methods-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.2.0 |
| <a name="module_pagopa-ecommerce-payment-methods-service_deploy"></a> [pagopa-ecommerce-payment-methods-service\_deploy](#module\_pagopa-ecommerce-payment-methods-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.2.0 |
| <a name="module_pagopa-ecommerce-payment-requests-service_code_review"></a> [pagopa-ecommerce-payment-requests-service\_code\_review](#module\_pagopa-ecommerce-payment-requests-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.2.0 |
| <a name="module_pagopa-ecommerce-payment-requests-service_deploy"></a> [pagopa-ecommerce-payment-requests-service\_deploy](#module\_pagopa-ecommerce-payment-requests-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.2.0 |
| <a name="module_pagopa-ecommerce-scheduler-service_code_review"></a> [pagopa-ecommerce-scheduler-service\_code\_review](#module\_pagopa-ecommerce-scheduler-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.4.0 |
| <a name="module_pagopa-ecommerce-scheduler-service_deploy"></a> [pagopa-ecommerce-scheduler-service\_deploy](#module\_pagopa-ecommerce-scheduler-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.4.0 |
| <a name="module_pagopa-ecommerce-sessions-service_code_review"></a> [pagopa-ecommerce-sessions-service\_code\_review](#module\_pagopa-ecommerce-sessions-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.2.0 |
| <a name="module_pagopa-ecommerce-sessions-service_deploy"></a> [pagopa-ecommerce-sessions-service\_deploy](#module\_pagopa-ecommerce-sessions-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.2.0 |
| <a name="module_pagopa-ecommerce-tests_soak"></a> [pagopa-ecommerce-tests\_soak](#module\_pagopa-ecommerce-tests\_soak) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v2.6.3 |
| <a name="module_pagopa-ecommerce-transactions-service_code_review"></a> [pagopa-ecommerce-transactions-service\_code\_review](#module\_pagopa-ecommerce-transactions-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.2.0 |
| <a name="module_pagopa-ecommerce-transactions-service_deploy"></a> [pagopa-ecommerce-transactions-service\_deploy](#module\_pagopa-ecommerce-transactions-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.2.0 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [terraform_remote_state.app](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_pagopa-ecommerce-payment-methods-service"></a> [pagopa-ecommerce-payment-methods-service](#input\_pagopa-ecommerce-payment-methods-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-ecommerce-payment-methods-service",<br>      "project_name": "pagopa-ecommerce-payment-methods-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-ecommerce-payment-methods-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-ecommerce-payment-requests-service"></a> [pagopa-ecommerce-payment-requests-service](#input\_pagopa-ecommerce-payment-requests-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-ecommerce-payment-requests-service",<br>      "project_name": "pagopa-ecommerce-payment-requests-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-ecommerce-payment-requests-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-ecommerce-scheduler-service"></a> [pagopa-ecommerce-scheduler-service](#input\_pagopa-ecommerce-scheduler-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-ecommerce-scheduler-service",<br>      "project_name": "pagopa-ecommerce-scheduler-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-ecommerce-scheduler-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-ecommerce-sessions-service"></a> [pagopa-ecommerce-sessions-service](#input\_pagopa-ecommerce-sessions-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-ecommerce-sessions-service",<br>      "project_name": "pagopa-ecommerce-sessions-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-ecommerce-sessions-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-ecommerce-tests"></a> [pagopa-ecommerce-tests](#input\_pagopa-ecommerce-tests) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_soak": true,<br>    "name": "soak-test-pipeline"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-ecommerce-tests",<br>    "organization": "pagopa",<br>    "pipeline_yml_filename": "soaktest.yaml",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-ecommerce-transactions-service"></a> [pagopa-ecommerce-transactions-service](#input\_pagopa-ecommerce-transactions-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-ecommerce-transactions-service",<br>      "project_name": "pagopa-ecommerce-transactions-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-ecommerce-transactions-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-notifications-service"></a> [pagopa-notifications-service](#input\_pagopa-notifications-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-notifications-service",<br>      "project_name": "pagopa-notifications-service",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-notifications-service",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_terraform_remote_state_app"></a> [terraform\_remote\_state\_app](#input\_terraform\_remote\_state\_app) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
