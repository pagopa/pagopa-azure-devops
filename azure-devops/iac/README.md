<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >= 0.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.99.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_afm_dev_secrets"></a> [afm\_dev\_secrets](#module\_afm\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_afm_iac_code_review"></a> [afm\_iac\_code\_review](#module\_afm\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.2 |
| <a name="module_afm_iac_deploy"></a> [afm\_iac\_deploy](#module\_afm\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.2 |
| <a name="module_apim_backup"></a> [apim\_backup](#module\_apim\_backup) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.4.0 |
| <a name="module_bizevents_dev_secrets"></a> [bizevents\_dev\_secrets](#module\_bizevents\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_bizevents_iac_code_review"></a> [bizevents\_iac\_code\_review](#module\_bizevents\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.2 |
| <a name="module_bizevents_iac_deploy"></a> [bizevents\_iac\_deploy](#module\_bizevents\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.2 |
| <a name="module_bizevents_uat_secrets"></a> [bizevents\_uat\_secrets](#module\_bizevents\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_ecommerce_dev_secrets"></a> [ecommerce\_dev\_secrets](#module\_ecommerce\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_ecommerce_iac_code_review"></a> [ecommerce\_iac\_code\_review](#module\_ecommerce\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.2 |
| <a name="module_ecommerce_iac_deploy"></a> [ecommerce\_iac\_deploy](#module\_ecommerce\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.2 |
| <a name="module_ecommerce_uat_secrets"></a> [ecommerce\_uat\_secrets](#module\_ecommerce\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_gps_dev_secrets"></a> [gps\_dev\_secrets](#module\_gps\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_gps_iac_code_review"></a> [gps\_iac\_code\_review](#module\_gps\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.2 |
| <a name="module_gps_iac_deploy"></a> [gps\_iac\_deploy](#module\_gps\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.2 |
| <a name="module_gps_prod_secrets"></a> [gps\_prod\_secrets](#module\_gps\_prod\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_gps_uat_secrets"></a> [gps\_uat\_secrets](#module\_gps\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_iac_core_code_review"></a> [iac\_core\_code\_review](#module\_iac\_core\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.3 |
| <a name="module_iac_core_deploy"></a> [iac\_core\_deploy](#module\_iac\_core\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.3 |
| <a name="module_nodo_dev_secrets"></a> [nodo\_dev\_secrets](#module\_nodo\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_nodo_iac_code_review"></a> [nodo\_iac\_code\_review](#module\_nodo\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.2 |
| <a name="module_nodo_iac_db_migration"></a> [nodo\_iac\_db\_migration](#module\_nodo\_iac\_db\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v2.6.3 |
| <a name="module_nodo_iac_db_schema"></a> [nodo\_iac\_db\_schema](#module\_nodo\_iac\_db\_schema) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v2.6.3 |
| <a name="module_nodo_iac_deploy"></a> [nodo\_iac\_deploy](#module\_nodo\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.2 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.0.4 |
| <a name="module_selfcare_dev_secrets"></a> [selfcare\_dev\_secrets](#module\_selfcare\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_selfcare_iac_code_review"></a> [selfcare\_iac\_code\_review](#module\_selfcare\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.2 |
| <a name="module_selfcare_iac_deploy"></a> [selfcare\_iac\_deploy](#module\_selfcare\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.2 |
| <a name="module_selfcare_prod_secrets"></a> [selfcare\_prod\_secrets](#module\_selfcare\_prod\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_selfcare_uat_secrets"></a> [selfcare\_uat\_secrets](#module\_selfcare\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_shared_dev_secrets"></a> [shared\_dev\_secrets](#module\_shared\_dev\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_shared_iac_code_review"></a> [shared\_iac\_code\_review](#module\_shared\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v2.6.2 |
| <a name="module_shared_iac_deploy"></a> [shared\_iac\_deploy](#module\_shared\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v2.6.2 |
| <a name="module_shared_prod_secrets"></a> [shared\_prod\_secrets](#module\_shared\_prod\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |
| <a name="module_shared_uat_secrets"></a> [shared\_uat\_secrets](#module\_shared\_uat\_secrets) | git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query | v2.18.9 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_environment.environments](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/environment) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project) | resource |
| [azuredevops_project_features.project_features](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project_features) | resource |
| [azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-pr](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-ro](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-rw](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_team.external_team](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/team) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_afm_iac"></a> [afm\_iac](#input\_afm\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "afm-infrastructure",<br>    "pipeline_name_prefix": "afm-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "afm"<br>  }<br>}</pre> | no |
| <a name="input_aks_dev_platform_name"></a> [aks\_dev\_platform\_name](#input\_aks\_dev\_platform\_name) | AKS DEV platform name | `string` | n/a | yes |
| <a name="input_aks_prod_platform_name"></a> [aks\_prod\_platform\_name](#input\_aks\_prod\_platform\_name) | AKS PROD platform name | `string` | n/a | yes |
| <a name="input_aks_uat_platform_name"></a> [aks\_uat\_platform\_name](#input\_aks\_uat\_platform\_name) | AKS UAT platform name | `string` | n/a | yes |
| <a name="input_apim_backup"></a> [apim\_backup](#input\_apim\_backup) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": false,<br>    "enable_deploy": true<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "backup-apim"<br>  }<br>}</pre> | no |
| <a name="input_bizevents_iac"></a> [bizevents\_iac](#input\_bizevents\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "bizevents-infrastructure",<br>    "pipeline_name_prefix": "bizevents-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "bizevents"<br>  }<br>}</pre> | no |
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_ecommerce_iac"></a> [ecommerce\_iac](#input\_ecommerce\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "ecommerce-infrastructure",<br>    "pipeline_name_prefix": "ecommerce-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "ecommerce"<br>  }<br>}</pre> | no |
| <a name="input_gps_iac"></a> [gps\_iac](#input\_gps\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "gps-infrastructure",<br>    "pipeline_name_prefix": "gps-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "gps"<br>  }<br>}</pre> | no |
| <a name="input_iac_core"></a> [iac\_core](#input\_iac\_core) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path_name": "core-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "core"<br>  }<br>}</pre> | no |
| <a name="input_nodo_iac"></a> [nodo\_iac](#input\_nodo\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "db_migration": {<br>      "name": "nodo-db-migration-pipelines",<br>      "pipeline_yml_filename": "nodo-db-migration-pipelines.yml"<br>    },<br>    "db_schema": {<br>      "name": "nodo-db-schema-pipelines",<br>      "pipeline_yml_filename": "nodo-db-schema-pipelines.yml"<br>    },<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "nodo-infrastructure",<br>    "pipeline_name_prefix": "nodo-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "nodo"<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name_prefix"></a> [project\_name\_prefix](#input\_project\_name\_prefix) | Project name prefix (e.g. userregistry) | `string` | n/a | yes |
| <a name="input_selfcare_iac"></a> [selfcare\_iac](#input\_selfcare\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "selfcare-infrastructure",<br>    "pipeline_name_prefix": "selfcare-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "selfcare"<br>  }<br>}</pre> | no |
| <a name="input_shared_iac"></a> [shared\_iac](#input\_shared\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "shared-infrastructure",<br>    "pipeline_name_prefix": "shared-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "shared"<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
