<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | <= 0.11.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.85.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN"></a> [DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN](#module\_DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v5.2.0 |
| <a name="module_DEV-AZURERM-IAC-PLAN-SERVICE-CONN"></a> [DEV-AZURERM-IAC-PLAN-SERVICE-CONN](#module\_DEV-AZURERM-IAC-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v5.2.0 |
| <a name="module_PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN"></a> [PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN](#module\_PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v5.2.0 |
| <a name="module_PROD-AZURERM-IAC-PLAN-SERVICE-CONN"></a> [PROD-AZURERM-IAC-PLAN-SERVICE-CONN](#module\_PROD-AZURERM-IAC-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v5.2.0 |
| <a name="module_UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN"></a> [UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN](#module\_UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v5.2.0 |
| <a name="module_UAT-AZURERM-IAC-PLAN-SERVICE-CONN"></a> [UAT-AZURERM-IAC-PLAN-SERVICE-CONN](#module\_UAT-AZURERM-IAC-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v5.2.0 |
| <a name="module_aca_dev_secrets"></a> [aca\_dev\_secrets](#module\_aca\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_aca_iac_code_review"></a> [aca\_iac\_code\_review](#module\_aca\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_aca_iac_deploy"></a> [aca\_iac\_deploy](#module\_aca\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_aca_prod_secrets"></a> [aca\_prod\_secrets](#module\_aca\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_aca_uat_secrets"></a> [aca\_uat\_secrets](#module\_aca\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_afm_dev_secrets"></a> [afm\_dev\_secrets](#module\_afm\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_afm_iac_code_review"></a> [afm\_iac\_code\_review](#module\_afm\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_afm_iac_deploy"></a> [afm\_iac\_deploy](#module\_afm\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_apim_backup"></a> [apim\_backup](#module\_apim\_backup) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_bizevents_dev_secrets"></a> [bizevents\_dev\_secrets](#module\_bizevents\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_bizevents_iac_code_review"></a> [bizevents\_iac\_code\_review](#module\_bizevents\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_bizevents_iac_deploy"></a> [bizevents\_iac\_deploy](#module\_bizevents\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_bizevents_uat_secrets"></a> [bizevents\_uat\_secrets](#module\_bizevents\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_checkout_iac_code_review"></a> [checkout\_iac\_code\_review](#module\_checkout\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_checkout_iac_deploy"></a> [checkout\_iac\_deploy](#module\_checkout\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_ecommerce_dev_secrets"></a> [ecommerce\_dev\_secrets](#module\_ecommerce\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_ecommerce_iac_code_review"></a> [ecommerce\_iac\_code\_review](#module\_ecommerce\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_ecommerce_iac_deploy"></a> [ecommerce\_iac\_deploy](#module\_ecommerce\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_ecommerce_prod_secrets"></a> [ecommerce\_prod\_secrets](#module\_ecommerce\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_ecommerce_uat_secrets"></a> [ecommerce\_uat\_secrets](#module\_ecommerce\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_fdr_dev_secrets"></a> [fdr\_dev\_secrets](#module\_fdr\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_fdr_iac_code_review"></a> [fdr\_iac\_code\_review](#module\_fdr\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_fdr_iac_db_migration"></a> [fdr\_iac\_db\_migration](#module\_fdr\_iac\_db\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v5.2.0 |
| <a name="module_fdr_iac_db_schema"></a> [fdr\_iac\_db\_schema](#module\_fdr\_iac\_db\_schema) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v5.2.0 |
| <a name="module_fdr_iac_deploy"></a> [fdr\_iac\_deploy](#module\_fdr\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_fdr_uat_secrets"></a> [fdr\_uat\_secrets](#module\_fdr\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_gps_dev_secrets"></a> [gps\_dev\_secrets](#module\_gps\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_gps_iac_code_review"></a> [gps\_iac\_code\_review](#module\_gps\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_gps_iac_deploy"></a> [gps\_iac\_deploy](#module\_gps\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_gps_prod_secrets"></a> [gps\_prod\_secrets](#module\_gps\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_gps_uat_secrets"></a> [gps\_uat\_secrets](#module\_gps\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_iac_core_code_review"></a> [iac\_core\_code\_review](#module\_iac\_core\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_iac_core_deploy"></a> [iac\_core\_deploy](#module\_iac\_core\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_iac_resource_switcher"></a> [iac\_resource\_switcher](#module\_iac\_resource\_switcher) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_resource_switcher | v5.2.0 |
| <a name="module_nodo_dev_secrets"></a> [nodo\_dev\_secrets](#module\_nodo\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_nodo_iac_code_review"></a> [nodo\_iac\_code\_review](#module\_nodo\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_nodo_iac_db_migration"></a> [nodo\_iac\_db\_migration](#module\_nodo\_iac\_db\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v5.2.0 |
| <a name="module_nodo_iac_db_schema"></a> [nodo\_iac\_db\_schema](#module\_nodo\_iac\_db\_schema) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v5.2.0 |
| <a name="module_nodo_iac_deploy"></a> [nodo\_iac\_deploy](#module\_nodo\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_nodo_iac_web_bo_db_migration"></a> [nodo\_iac\_web\_bo\_db\_migration](#module\_nodo\_iac\_web\_bo\_db\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v5.2.0 |
| <a name="module_nodo_iac_web_bo_db_schema"></a> [nodo\_iac\_web\_bo\_db\_schema](#module\_nodo\_iac\_web\_bo\_db\_schema) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v5.2.0 |
| <a name="module_nodo_prod_secrets"></a> [nodo\_prod\_secrets](#module\_nodo\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_nodo_uat_secrets"></a> [nodo\_uat\_secrets](#module\_nodo\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_qi_dev_secrets"></a> [qi\_dev\_secrets](#module\_qi\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_qi_iac_code_review"></a> [qi\_iac\_code\_review](#module\_qi\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_qi_iac_deploy"></a> [qi\_iac\_deploy](#module\_qi\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_qi_uat_secrets"></a> [qi\_uat\_secrets](#module\_qi\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_selfcare_dev_secrets"></a> [selfcare\_dev\_secrets](#module\_selfcare\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_selfcare_iac_code_review"></a> [selfcare\_iac\_code\_review](#module\_selfcare\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_selfcare_iac_deploy"></a> [selfcare\_iac\_deploy](#module\_selfcare\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_selfcare_prod_secrets"></a> [selfcare\_prod\_secrets](#module\_selfcare\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_selfcare_uat_secrets"></a> [selfcare\_uat\_secrets](#module\_selfcare\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_shared_dev_secrets"></a> [shared\_dev\_secrets](#module\_shared\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_shared_iac_code_review"></a> [shared\_iac\_code\_review](#module\_shared\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_shared_iac_deploy"></a> [shared\_iac\_deploy](#module\_shared\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_shared_prod_secrets"></a> [shared\_prod\_secrets](#module\_shared\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_shared_uat_secrets"></a> [shared\_uat\_secrets](#module\_shared\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_wallet_dev_secrets"></a> [wallet\_dev\_secrets](#module\_wallet\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |
| <a name="module_wallet_iac_code_review"></a> [wallet\_iac\_code\_review](#module\_wallet\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v5.2.0 |
| <a name="module_wallet_iac_deploy"></a> [wallet\_iac\_deploy](#module\_wallet\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v5.2.0 |
| <a name="module_wallet_uat_secrets"></a> [wallet\_uat\_secrets](#module\_wallet\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.47.2 |

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
| [azurerm_role_assignment.dev_plan_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.prod_plan_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uat_plan_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscriptions.dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aca_iac"></a> [aca\_iac](#input\_aca\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "aca-infrastructure",<br>    "pipeline_name_prefix": "aca-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "aca"<br>  }<br>}</pre> | no |
| <a name="input_afm_iac"></a> [afm\_iac](#input\_afm\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "afm-infrastructure",<br>    "pipeline_name_prefix": "afm-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "afm"<br>  }<br>}</pre> | no |
| <a name="input_aks_dev_platform_name"></a> [aks\_dev\_platform\_name](#input\_aks\_dev\_platform\_name) | AKS DEV platform name | `string` | n/a | yes |
| <a name="input_aks_prod_platform_name"></a> [aks\_prod\_platform\_name](#input\_aks\_prod\_platform\_name) | AKS PROD platform name | `string` | n/a | yes |
| <a name="input_aks_uat_platform_name"></a> [aks\_uat\_platform\_name](#input\_aks\_uat\_platform\_name) | AKS UAT platform name | `string` | n/a | yes |
| <a name="input_apim_backup"></a> [apim\_backup](#input\_apim\_backup) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": false,<br>    "enable_deploy": true<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "backup-apim"<br>  }<br>}</pre> | no |
| <a name="input_bizevents_iac"></a> [bizevents\_iac](#input\_bizevents\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "bizevents-infrastructure",<br>    "pipeline_name_prefix": "bizevents-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "bizevents"<br>  }<br>}</pre> | no |
| <a name="input_checkout_iac"></a> [checkout\_iac](#input\_checkout\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "checkout-infrastructure",<br>    "pipeline_name_prefix": "checkout-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "checkout"<br>  }<br>}</pre> | no |
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_ecommerce_iac"></a> [ecommerce\_iac](#input\_ecommerce\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "ecommerce-infrastructure",<br>    "pipeline_name_prefix": "ecommerce-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "ecommerce"<br>  }<br>}</pre> | no |
| <a name="input_fdr_iac"></a> [fdr\_iac](#input\_fdr\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "db_migration": {<br>      "name": "fdr-db-migration-pipelines",<br>      "pipeline_yml_filename": "fdr-db-migration-pipelines.yml"<br>    },<br>    "db_schema": {<br>      "name": "fdr-db-schema-pipelines",<br>      "pipeline_yml_filename": "fdr-db-schema-pipelines.yml"<br>    },<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "fdr-infrastructure",<br>    "pipeline_name_prefix": "fdr-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "fdr"<br>  }<br>}</pre> | no |
| <a name="input_gps_iac"></a> [gps\_iac](#input\_gps\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "gps-infrastructure",<br>    "pipeline_name_prefix": "gps-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "gps"<br>  }<br>}</pre> | no |
| <a name="input_iac_core"></a> [iac\_core](#input\_iac\_core) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path_name": "core-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "core"<br>  }<br>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_nodo_iac"></a> [nodo\_iac](#input\_nodo\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "db_migration": {<br>      "name": "nodo-db-migration-pipelines",<br>      "pipeline_yml_filename": "nodo-db-migration-pipelines.yml"<br>    },<br>    "db_schema": {<br>      "name": "nodo-db-schema-pipelines",<br>      "pipeline_yml_filename": "nodo-db-schema-pipelines.yml"<br>    },<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "nodo-infrastructure",<br>    "pipeline_name_prefix": "nodo-infra",<br>    "sync_schema_cfg_grant": {<br>      "name": "sync-schema-cfg-grant-pipelines",<br>      "pipeline_yml_filename": "nodo-sync-grant-schema-cfg-pipelines.yml"<br>    },<br>    "web_bo_db_migration": {<br>      "name": "web-bo-db-migration-pipelines",<br>      "pipeline_yml_filename": "web-bo-db-migration-pipelines.yml"<br>    },<br>    "web_bo_db_schema": {<br>      "name": "web-bo-db-schema-pipelines",<br>      "pipeline_yml_filename": "web-bo-db-schema-pipelines.yml"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "nodo"<br>  }<br>}</pre> | no |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name_prefix"></a> [project\_name\_prefix](#input\_project\_name\_prefix) | Project name prefix (e.g. userregistry) | `string` | n/a | yes |
| <a name="input_qi_iac"></a> [qi\_iac](#input\_qi\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "qi-infrastructure",<br>    "pipeline_name_prefix": "qi-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "qi"<br>  }<br>}</pre> | no |
| <a name="input_selfcare_iac"></a> [selfcare\_iac](#input\_selfcare\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "selfcare-infrastructure",<br>    "pipeline_name_prefix": "selfcare-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "selfcare"<br>  }<br>}</pre> | no |
| <a name="input_shared_iac"></a> [shared\_iac](#input\_shared\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "shared-infrastructure",<br>    "pipeline_name_prefix": "shared-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "shared"<br>  }<br>}</pre> | no |
| <a name="input_switcher_iac"></a> [switcher\_iac](#input\_switcher\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable": true,<br>    "path": "switcher"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "eng-common-scripts",<br>    "organization": "pagopa",<br>    "pipelines_path": "devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |
| <a name="input_wallet_iac"></a> [wallet\_iac](#input\_wallet\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "wallet-infrastructure",<br>    "pipeline_name_prefix": "wallet-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "wallet"<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
