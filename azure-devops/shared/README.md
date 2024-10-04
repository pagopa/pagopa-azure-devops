<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | ~> 0.10.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.85.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-APPINSIGHTS-SERVICE-CONN"></a> [DEV-APPINSIGHTS-SERVICE-CONN](#module\_DEV-APPINSIGHTS-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_PROD-APPINSIGHTS-SERVICE-CONN"></a> [PROD-APPINSIGHTS-SERVICE-CONN](#module\_PROD-APPINSIGHTS-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_UAT-APPINSIGHTS-SERVICE-CONN"></a> [UAT-APPINSIGHTS-SERVICE-CONN](#module\_UAT-APPINSIGHTS-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v4.2.1 |
| <a name="module_pagopa-iuv-generator-service_code_review"></a> [pagopa-iuv-generator-service\_code\_review](#module\_pagopa-iuv-generator-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-iuv-generator-service_deploy"></a> [pagopa-iuv-generator-service\_deploy](#module\_pagopa-iuv-generator-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-pdf-engine-service_deploy"></a> [pagopa-pdf-engine-service\_deploy](#module\_pagopa-pdf-engine-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-pdf-engine_performance_test"></a> [pagopa-pdf-engine\_performance\_test](#module\_pagopa-pdf-engine\_performance\_test) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v4.2.1 |
| <a name="module_pagopa-platform-authorizer-service_code_review"></a> [pagopa-platform-authorizer-service\_code\_review](#module\_pagopa-platform-authorizer-service\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-platform-authorizer-service_deploy"></a> [pagopa-platform-authorizer-service\_deploy](#module\_pagopa-platform-authorizer-service\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-poc-micronaut_code_review"></a> [pagopa-poc-micronaut\_code\_review](#module\_pagopa-poc-micronaut\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-poc-micronaut_deploy"></a> [pagopa-poc-micronaut\_deploy](#module\_pagopa-poc-micronaut\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-poc-micronaut_performance_test"></a> [pagopa-poc-micronaut\_performance\_test](#module\_pagopa-poc-micronaut\_performance\_test) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v4.2.1 |
| <a name="module_pagopa-poc-quarkus_code_review"></a> [pagopa-poc-quarkus\_code\_review](#module\_pagopa-poc-quarkus\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-poc-quarkus_deploy"></a> [pagopa-poc-quarkus\_deploy](#module\_pagopa-poc-quarkus\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-poc-quarkus_performance_test"></a> [pagopa-poc-quarkus\_performance\_test](#module\_pagopa-poc-quarkus\_performance\_test) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v4.2.1 |
| <a name="module_pagopa-taxonomy_deploy"></a> [pagopa-taxonomy\_deploy](#module\_pagopa-taxonomy\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_pagopa-tkm-mock-circuit_code_review"></a> [pagopa-tkm-mock-circuit\_code\_review](#module\_pagopa-tkm-mock-circuit\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.1.1 |
| <a name="module_pagopa-tkm-mock-circuit_deploy"></a> [pagopa-tkm-mock-circuit\_deploy](#module\_pagopa-tkm-mock-circuit\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v4.2.1 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_shared_dev_secrets"></a> [shared\_dev\_secrets](#module\_shared\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_shared_prod_secrets"></a> [shared\_prod\_secrets](#module\_shared\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |
| <a name="module_shared_uat_secrets"></a> [shared\_uat\_secrets](#module\_shared\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.30.0 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_kubernetes.aks_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azuredevops_serviceendpoint_kubernetes.aks_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_kubernetes) | resource |
| [azurerm_role_assignment.appinsights_component_contributor_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.appinsights_component_contributor_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.appinsights_component_contributor_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azuredevops_serviceendpoint_azurecr.dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.itn_dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.itn_prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.itn_uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurecr.uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurecr) | data source |
| [azuredevops_serviceendpoint_azurerm.dev](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_azurerm.prod](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_azurerm.uat](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_azurerm) | data source |
| [azuredevops_serviceendpoint_github.github_pr](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.github_ro](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azuredevops_serviceendpoint_github.github_rw](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/serviceendpoint_github) | data source |
| [azurerm_application_insights.application_insights_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_application_insights.application_insights_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_application_insights.application_insights_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscriptions.dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_pagopa-iuv-generator-service"></a> [pagopa-iuv-generator-service](#input\_pagopa-iuv-generator-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-iuv-generator",<br>      "project_name": "pagopa-iuv-generator",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-iuv-generator",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-pdf-engine"></a> [pagopa-pdf-engine](#input\_pagopa-pdf-engine) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_deploy": true,<br>    "performance_test": {<br>      "enabled": true,<br>      "name": "performance-test-pipeline",<br>      "pipeline_yml_filename": "performance-test-pipelines.yml"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-pdf-engine",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-platform-authorizer-service"></a> [pagopa-platform-authorizer-service](#input\_pagopa-platform-authorizer-service) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-platform-authorizer",<br>      "project_name": "pagopa-platform-authorizer",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-platform-authorizer",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-poc-micronaut"></a> [pagopa-poc-micronaut](#input\_pagopa-poc-micronaut) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "performance_test": {<br>      "enabled": true,<br>      "name": "performance-test-pipeline",<br>      "pipeline_yml_filename": "performance-test-pipelines.yml"<br>    },<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-poc-micronaut",<br>      "project_name": "pagopa-poc-micronaut",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-poc-micronaut",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-poc-quarkus"></a> [pagopa-poc-quarkus](#input\_pagopa-poc-quarkus) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "performance_test": {<br>      "enabled": true,<br>      "name": "performance-test-pipeline",<br>      "pipeline_yml_filename": "performance-test-pipelines.yml"<br>    },<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-poc-quarkus",<br>      "project_name": "pagopa-poc-quarkus",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-poc-quarkus",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-taxonomy"></a> [pagopa-taxonomy](#input\_pagopa-taxonomy) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": false,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_pagopa-taxonomy",<br>      "project_name": "pagopa-taxonomy",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-taxonomy",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pagopa-tkm-mock-circuit"></a> [pagopa-tkm-mock-circuit](#input\_pagopa-tkm-mock-circuit) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "sonarcloud": {<br>      "org": "pagopa",<br>      "project_key": "pagopa_tkm-mock-circuit",<br>      "project_name": "tkm-mock-circuit",<br>      "service_connection": "SONARCLOUD-SERVICE-CONN"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/develop",<br>    "name": "tkm-mock-circuit",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name (e.g. pagoPA platform) | `string` | n/a | yes |
| <a name="input_service_connection_dev_acr_name"></a> [service\_connection\_dev\_acr\_name](#input\_service\_connection\_dev\_acr\_name) | ACR service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_dev_azurerm_name"></a> [service\_connection\_dev\_azurerm\_name](#input\_service\_connection\_dev\_azurerm\_name) | Azurerm service connection DEV name | `string` | n/a | yes |
| <a name="input_service_connection_prod_acr_name"></a> [service\_connection\_prod\_acr\_name](#input\_service\_connection\_prod\_acr\_name) | ACR service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_prod_azurerm_name"></a> [service\_connection\_prod\_azurerm\_name](#input\_service\_connection\_prod\_azurerm\_name) | Azurerm service connection PROD name | `string` | n/a | yes |
| <a name="input_service_connection_uat_acr_name"></a> [service\_connection\_uat\_acr\_name](#input\_service\_connection\_uat\_acr\_name) | ACR service connection UAT name | `string` | n/a | yes |
| <a name="input_service_connection_uat_azurerm_name"></a> [service\_connection\_uat\_azurerm\_name](#input\_service\_connection\_uat\_azurerm\_name) | Azurerm service connection UAT name | `string` | n/a | yes |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
