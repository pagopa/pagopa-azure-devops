<!-- markdownlint-disable -->
# IaC pipeline definition

This module defines the iac pipelines (code review and deploy)

The creation of pipeline definition is based on a configuration structure defined in `99_locals.tf` described below

```hcl
definitions =  [
    {
      name: "payhub",
      envs: ["d"],
      kv_name: "p4pa-%s-payhub-kv",
      rg_name: "p4pa-%s-itn-payhub-sec-rg",
      code_review: true,
      deploy: true,
      pipeline_prefix: "payhub-infra",
      pipeline_path: "payhub-infrastructure",
      repository: {
        yml_prefix_name: "payhub"
        branch_name     = "azdo-iac-pipelines"
      }
    },
  ]

  domain_variables = {
    payhub = {
      iac_variables_cr: {},
      iac_variables_secrets_cr: {},
      iac_variables_deploy: {},
      iac_variables_secrets_deploy: {}
    }
  }
```

## definitions
The `definitions` section defines the definitions for which the pipelines definitions have to be created:

- **name**: name of the domain
- **envs**: list of environments (initials) in which the domain resource are available {`d`, `u`, `p`}. Used to avoid failures when a domain keyvault has not been created on a certain environment
- **kv_name**: name of the domain keyvault. must contain the placeholder string `%s` in place of the environment; will be resolved at run time
- **rg_name**: resource group name of the domain keyvault. must contain the placeholder string `%s` in place of the environment; will be resolved at run time
- **code_review**: if true, enables the creation of the code review pipeline
- **deploy**: if true, enables the creation of the deploy pipeline
- **pipeline_prefix**: prefix assigned to the pipelines being created
- **pipeline_path**: AZDO folder path in which the pipelines will be created
- **repository**: overrides the default respository defined in `04_iac.tf`
  - **yml_prefix_name**: REQUIRED. prefix used to identify this domain `yaml` files.
    the default repository configuration is the following:
```hcl
default_repository = {
    organization    = "pagopa"
    name            = "p4pa-infra"
    branch_name     = "refs/heads/main"
    pipelines_path  = ".devops"
  }
```
any field can be overwritten in the `repository` field

To create pipelines for a new domain simply add the domain configuration to the list and apply the terraform configuration

## domain_variables

If a domain requires additional variables, they can be defined using the `domain_variables` structure; it allows defining different variables and secrets for the code review (`cr`) and deploy pipelines

the structure is the following:

- **<domain_name>**: matches the domain name defined in `definitions`
  - **iac_variables_cr**: variables for code review
  - **iac_variables_secrets_cr**: secrets for code review
  - **iac_variables_deploy**: variables for deploy
  - **iac_variables_secrets_deploy**: secrets for deploy<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.5 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | <= 0.11.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.80.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN"></a> [DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN](#module\_DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.0.0 |
| <a name="module_DEV-AZURERM-IAC-PLAN-SERVICE-CONN"></a> [DEV-AZURERM-IAC-PLAN-SERVICE-CONN](#module\_DEV-AZURERM-IAC-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.0.0 |
| <a name="module_DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN"></a> [DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN](#module\_DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan | v7.2.0 |
| <a name="module_PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN"></a> [PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN](#module\_PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.0.0 |
| <a name="module_PROD-AZURERM-IAC-PLAN-SERVICE-CONN"></a> [PROD-AZURERM-IAC-PLAN-SERVICE-CONN](#module\_PROD-AZURERM-IAC-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.0.0 |
| <a name="module_PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN"></a> [PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN](#module\_PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan | v7.2.0 |
| <a name="module_UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN"></a> [UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN](#module\_UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.0.0 |
| <a name="module_UAT-AZURERM-IAC-PLAN-SERVICE-CONN"></a> [UAT-AZURERM-IAC-PLAN-SERVICE-CONN](#module\_UAT-AZURERM-IAC-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated | v7.0.0 |
| <a name="module_UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN"></a> [UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN](#module\_UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan | v7.2.0 |
| <a name="module_aca_dev_secrets"></a> [aca\_dev\_secrets](#module\_aca\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_aca_iac_code_review"></a> [aca\_iac\_code\_review](#module\_aca\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_aca_iac_deploy"></a> [aca\_iac\_deploy](#module\_aca\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_aca_prod_secrets"></a> [aca\_prod\_secrets](#module\_aca\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_aca_uat_secrets"></a> [aca\_uat\_secrets](#module\_aca\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_afm_dev_secrets"></a> [afm\_dev\_secrets](#module\_afm\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_afm_iac_code_review"></a> [afm\_iac\_code\_review](#module\_afm\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_afm_iac_deploy"></a> [afm\_iac\_deploy](#module\_afm\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_afm_prod_secrets"></a> [afm\_prod\_secrets](#module\_afm\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_afm_uat_secrets"></a> [afm\_uat\_secrets](#module\_afm\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_apiconfig_dev_secrets"></a> [apiconfig\_dev\_secrets](#module\_apiconfig\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_apiconfig_iac_code_review"></a> [apiconfig\_iac\_code\_review](#module\_apiconfig\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_apiconfig_iac_deploy"></a> [apiconfig\_iac\_deploy](#module\_apiconfig\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_apiconfig_prod_secrets"></a> [apiconfig\_prod\_secrets](#module\_apiconfig\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_apiconfig_uat_secrets"></a> [apiconfig\_uat\_secrets](#module\_apiconfig\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_apim_backup"></a> [apim\_backup](#module\_apim\_backup) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_bizevents_dev_secrets"></a> [bizevents\_dev\_secrets](#module\_bizevents\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_bizevents_iac_code_review"></a> [bizevents\_iac\_code\_review](#module\_bizevents\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_bizevents_iac_deploy"></a> [bizevents\_iac\_deploy](#module\_bizevents\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_bizevents_prod_secrets"></a> [bizevents\_prod\_secrets](#module\_bizevents\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_bizevents_uat_secrets"></a> [bizevents\_uat\_secrets](#module\_bizevents\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_canoneunico_iac_code_review"></a> [canoneunico\_iac\_code\_review](#module\_canoneunico\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_canoneunico_iac_deploy"></a> [canoneunico\_iac\_deploy](#module\_canoneunico\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_dev_secrets"></a> [dev\_secrets](#module\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_disaster_recovery"></a> [disaster\_recovery](#module\_disaster\_recovery) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.1.0 |
| <a name="module_ecommerce_dev_secrets"></a> [ecommerce\_dev\_secrets](#module\_ecommerce\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_ecommerce_iac_code_review"></a> [ecommerce\_iac\_code\_review](#module\_ecommerce\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_ecommerce_iac_deploy"></a> [ecommerce\_iac\_deploy](#module\_ecommerce\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_ecommerce_prod_secrets"></a> [ecommerce\_prod\_secrets](#module\_ecommerce\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_ecommerce_uat_secrets"></a> [ecommerce\_uat\_secrets](#module\_ecommerce\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_fdr_dev_secrets"></a> [fdr\_dev\_secrets](#module\_fdr\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_fdr_iac_code_review"></a> [fdr\_iac\_code\_review](#module\_fdr\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_fdr_iac_db_migration"></a> [fdr\_iac\_db\_migration](#module\_fdr\_iac\_db\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.0.0 |
| <a name="module_fdr_iac_db_schema"></a> [fdr\_iac\_db\_schema](#module\_fdr\_iac\_db\_schema) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.0.0 |
| <a name="module_fdr_iac_deploy"></a> [fdr\_iac\_deploy](#module\_fdr\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_fdr_prod_secrets"></a> [fdr\_prod\_secrets](#module\_fdr\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_fdr_uat_secrets"></a> [fdr\_uat\_secrets](#module\_fdr\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_gps_dev_secrets"></a> [gps\_dev\_secrets](#module\_gps\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_gps_iac_code_review"></a> [gps\_iac\_code\_review](#module\_gps\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_gps_iac_deploy"></a> [gps\_iac\_deploy](#module\_gps\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_gps_prod_secrets"></a> [gps\_prod\_secrets](#module\_gps\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_gps_uat_secrets"></a> [gps\_uat\_secrets](#module\_gps\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_iac_checkout_code_review"></a> [iac\_checkout\_code\_review](#module\_iac\_checkout\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_iac_checkout_deploy"></a> [iac\_checkout\_deploy](#module\_iac\_checkout\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_iac_code_review"></a> [iac\_code\_review](#module\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_iac_core_code_review"></a> [iac\_core\_code\_review](#module\_iac\_core\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_iac_core_deploy"></a> [iac\_core\_deploy](#module\_iac\_core\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_iac_deploy"></a> [iac\_deploy](#module\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_iac_next_core_code_review"></a> [iac\_next\_core\_code\_review](#module\_iac\_next\_core\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_iac_next_core_deploy"></a> [iac\_next\_core\_deploy](#module\_iac\_next\_core\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_iac_resource_switcher"></a> [iac\_resource\_switcher](#module\_iac\_resource\_switcher) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_resource_switcher | v7.0.0 |
| <a name="module_mock_dev_secrets"></a> [mock\_dev\_secrets](#module\_mock\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_mock_iac_code_review"></a> [mock\_iac\_code\_review](#module\_mock\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_mock_iac_deploy"></a> [mock\_iac\_deploy](#module\_mock\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_nodo_dev_secrets"></a> [nodo\_dev\_secrets](#module\_nodo\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_nodo_iac_code_review"></a> [nodo\_iac\_code\_review](#module\_nodo\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_nodo_iac_db_migration"></a> [nodo\_iac\_db\_migration](#module\_nodo\_iac\_db\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.0.0 |
| <a name="module_nodo_iac_db_partitioned_data_migration"></a> [nodo\_iac\_db\_partitioned\_data\_migration](#module\_nodo\_iac\_db\_partitioned\_data\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.0.0 |
| <a name="module_nodo_iac_db_schema"></a> [nodo\_iac\_db\_schema](#module\_nodo\_iac\_db\_schema) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.0.0 |
| <a name="module_nodo_iac_deploy"></a> [nodo\_iac\_deploy](#module\_nodo\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_nodo_iac_web_bo_db_migration"></a> [nodo\_iac\_web\_bo\_db\_migration](#module\_nodo\_iac\_web\_bo\_db\_migration) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.0.0 |
| <a name="module_nodo_iac_web_bo_db_schema"></a> [nodo\_iac\_web\_bo\_db\_schema](#module\_nodo\_iac\_web\_bo\_db\_schema) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic | v7.0.0 |
| <a name="module_nodo_prod_secrets"></a> [nodo\_prod\_secrets](#module\_nodo\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_nodo_uat_secrets"></a> [nodo\_uat\_secrets](#module\_nodo\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_observability_iac_code_review"></a> [observability\_iac\_code\_review](#module\_observability\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_observability_iac_deploy"></a> [observability\_iac\_deploy](#module\_observability\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_packer_image_iac_deploy"></a> [packer\_image\_iac\_deploy](#module\_packer\_image\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.1.0 |
| <a name="module_pay_wallet_iac_code_review"></a> [pay\_wallet\_iac\_code\_review](#module\_pay\_wallet\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_pay_wallet_iac_deploy"></a> [pay\_wallet\_iac\_deploy](#module\_pay\_wallet\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_paywallet_dev_secrets"></a> [paywallet\_dev\_secrets](#module\_paywallet\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.13.0 |
| <a name="module_paywallet_prod_secrets"></a> [paywallet\_prod\_secrets](#module\_paywallet\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.13.0 |
| <a name="module_paywallet_uat_secrets"></a> [paywallet\_uat\_secrets](#module\_paywallet\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.13.0 |
| <a name="module_printit_dev_secrets"></a> [printit\_dev\_secrets](#module\_printit\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.13.0 |
| <a name="module_printit_prod_secrets"></a> [printit\_prod\_secrets](#module\_printit\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.13.0 |
| <a name="module_printit_uat_secrets"></a> [printit\_uat\_secrets](#module\_printit\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v8.13.0 |
| <a name="module_prod_secrets"></a> [prod\_secrets](#module\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_qi_dev_secrets"></a> [qi\_dev\_secrets](#module\_qi\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_qi_iac_code_review"></a> [qi\_iac\_code\_review](#module\_qi\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_qi_iac_deploy"></a> [qi\_iac\_deploy](#module\_qi\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_qi_prod_secrets"></a> [qi\_prod\_secrets](#module\_qi\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_qi_uat_secrets"></a> [qi\_uat\_secrets](#module\_qi\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_receipts_dev_secrets"></a> [receipts\_dev\_secrets](#module\_receipts\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_receipts_iac_code_review"></a> [receipts\_iac\_code\_review](#module\_receipts\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_receipts_iac_deploy"></a> [receipts\_iac\_deploy](#module\_receipts\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_receipts_prod_secrets"></a> [receipts\_prod\_secrets](#module\_receipts\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.39.0 |
| <a name="module_receipts_uat_secrets"></a> [receipts\_uat\_secrets](#module\_receipts\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_selfcare_dev_secrets"></a> [selfcare\_dev\_secrets](#module\_selfcare\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_selfcare_iac_code_review"></a> [selfcare\_iac\_code\_review](#module\_selfcare\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_selfcare_iac_deploy"></a> [selfcare\_iac\_deploy](#module\_selfcare\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_selfcare_prod_secrets"></a> [selfcare\_prod\_secrets](#module\_selfcare\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_selfcare_uat_secrets"></a> [selfcare\_uat\_secrets](#module\_selfcare\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_shared_dev_secrets"></a> [shared\_dev\_secrets](#module\_shared\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_shared_iac_code_review"></a> [shared\_iac\_code\_review](#module\_shared\_iac\_code\_review) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review | v7.0.0 |
| <a name="module_shared_iac_deploy"></a> [shared\_iac\_deploy](#module\_shared\_iac\_deploy) | git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy | v7.0.0 |
| <a name="module_shared_prod_secrets"></a> [shared\_prod\_secrets](#module\_shared\_prod\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_shared_uat_secrets"></a> [shared\_uat\_secrets](#module\_shared\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_uat_secrets"></a> [uat\_secrets](#module\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_wallet_dev_secrets"></a> [wallet\_dev\_secrets](#module\_wallet\_dev\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |
| <a name="module_wallet_uat_secrets"></a> [wallet\_uat\_secrets](#module\_wallet\_uat\_secrets) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v7.48.0 |

## Resources

| Name | Type |
|------|------|
| [azuredevops_environment.environments](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/environment) | resource |
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project) | resource |
| [azuredevops_project_features.project_features](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project_features) | resource |
| [azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-pr](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-ro](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_serviceendpoint_github.azure-devops-github-rw](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_github) | resource |
| [azuredevops_team.external_team](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/team) | resource |
| [azurerm_role_assignment.dev_apply_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.dev_plan_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.plan_legacy_iac_dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.plan_legacy_iac_prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.plan_legacy_iac_uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.prod_apply_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.prod_plan_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uat_apply_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uat_plan_permissions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscriptions.dev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.prod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |
| [azurerm_subscriptions.uat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_dev_platform_name"></a> [aks\_dev\_platform\_name](#input\_aks\_dev\_platform\_name) | AKS DEV platform name | `string` | n/a | yes |
| <a name="input_aks_prod_platform_name"></a> [aks\_prod\_platform\_name](#input\_aks\_prod\_platform\_name) | AKS PROD platform name | `string` | n/a | yes |
| <a name="input_aks_uat_platform_name"></a> [aks\_uat\_platform\_name](#input\_aks\_uat\_platform\_name) | AKS UAT platform name | `string` | n/a | yes |
| <a name="input_dev_subscription_name"></a> [dev\_subscription\_name](#input\_dev\_subscription\_name) | DEV Subscription name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_pipeline_environments"></a> [pipeline\_environments](#input\_pipeline\_environments) | List of environments pipeline to create | `list(any)` | n/a | yes |
| <a name="input_prod_subscription_name"></a> [prod\_subscription\_name](#input\_prod\_subscription\_name) | PROD Subscription name | `string` | n/a | yes |
| <a name="input_project_name_prefix"></a> [project\_name\_prefix](#input\_project\_name\_prefix) | Project name prefix (e.g. userregistry) | `string` | n/a | yes |
| <a name="input_uat_subscription_name"></a> [uat\_subscription\_name](#input\_uat\_subscription\_name) | UAT Subscription name | `string` | n/a | yes |
| <a name="input_aca_iac"></a> [aca\_iac](#input\_aca\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "aca-infrastructure",<br>    "pipeline_name_prefix": "aca-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "aca"<br>  }<br>}</pre> | no |
| <a name="input_afm_iac"></a> [afm\_iac](#input\_afm\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "afm-infrastructure",<br>    "pipeline_name_prefix": "afm-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "afm"<br>  }<br>}</pre> | no |
| <a name="input_apiconfig_iac"></a> [apiconfig\_iac](#input\_apiconfig\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "apiconfig-infrastructure",<br>    "pipeline_name_prefix": "apiconfig-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "apiconfig"<br>  }<br>}</pre> | no |
| <a name="input_apim_backup"></a> [apim\_backup](#input\_apim\_backup) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": false,<br>    "enable_deploy": true<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "backup-apim"<br>  }<br>}</pre> | no |
| <a name="input_azdo_iac"></a> [azdo\_iac](#input\_azdo\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "packer-image",<br>    "pipeline_name_prefix": "packer"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "packer"<br>  }<br>}</pre> | no |
| <a name="input_bizevents_iac"></a> [bizevents\_iac](#input\_bizevents\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "bizevents-infrastructure",<br>    "pipeline_name_prefix": "bizevents-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "bizevents"<br>  }<br>}</pre> | no |
| <a name="input_canoneunico_iac"></a> [canoneunico\_iac](#input\_canoneunico\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "canoneunico-infrastructure",<br>    "pipeline_name_prefix": "canoneunico-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "canoneunico"<br>  }<br>}</pre> | no |
| <a name="input_disaster_recovery"></a> [disaster\_recovery](#input\_disaster\_recovery) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": false,<br>    "enable_deploy": true<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "disaster-recovery"<br>  }<br>}</pre> | no |
| <a name="input_ecommerce_iac"></a> [ecommerce\_iac](#input\_ecommerce\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "ecommerce-infrastructure",<br>    "pipeline_name_prefix": "ecommerce-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "ecommerce"<br>  }<br>}</pre> | no |
| <a name="input_fdr_iac"></a> [fdr\_iac](#input\_fdr\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "db_migration": {<br>      "name": "fdr-db-migration-pipelines",<br>      "pipeline_yml_filename": "fdr-db-migration-pipelines.yml"<br>    },<br>    "db_schema": {<br>      "name": "fdr-db-schema-pipelines",<br>      "pipeline_yml_filename": "fdr-db-schema-pipelines.yml"<br>    },<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "fdr-infrastructure",<br>    "pipeline_name_prefix": "fdr-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "fdr"<br>  }<br>}</pre> | no |
| <a name="input_gps_iac"></a> [gps\_iac](#input\_gps\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "gps-infrastructure",<br>    "pipeline_name_prefix": "gps-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "gps"<br>  }<br>}</pre> | no |
| <a name="input_iac_checkout"></a> [iac\_checkout](#input\_iac\_checkout) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path_name": "checkout-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "checkout"<br>  }<br>}</pre> | no |
| <a name="input_iac_core"></a> [iac\_core](#input\_iac\_core) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path_name": "core-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "core"<br>  }<br>}</pre> | no |
| <a name="input_iac_next_core"></a> [iac\_next\_core](#input\_iac\_next\_core) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path_name": "next-core-infra",<br>    "pipeline_name_prefix": "next-core-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "next-core"<br>  }<br>}</pre> | no |
| <a name="input_mock_iac"></a> [mock\_iac](#input\_mock\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "mock-infrastructure",<br>    "pipeline_name_prefix": "mock-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "mock"<br>  }<br>}</pre> | no |
| <a name="input_nodo_iac"></a> [nodo\_iac](#input\_nodo\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "db_migration": {<br>      "name": "nodo-db-migration-pipelines",<br>      "pipeline_yml_filename": "nodo-db-migration-pipelines.yml"<br>    },<br>    "db_partitioned_data_migration": {<br>      "name": "nodo-partitioned-db-data-migration-pipelines",<br>      "pipeline_yml_filename": "nodo-partitioned-db-data-migration-pipelines.yml"<br>    },<br>    "db_schema": {<br>      "name": "nodo-db-schema-pipelines",<br>      "pipeline_yml_filename": "nodo-db-schema-pipelines.yml"<br>    },<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "nodo-infrastructure",<br>    "pipeline_name_prefix": "nodo-infra",<br>    "sync_schema_cfg_grant": {<br>      "name": "sync-schema-cfg-grant-pipelines",<br>      "pipeline_yml_filename": "nodo-sync-grant-schema-cfg-pipelines.yml"<br>    },<br>    "web_bo_db_migration": {<br>      "name": "web-bo-db-migration-pipelines",<br>      "pipeline_yml_filename": "web-bo-db-migration-pipelines.yml"<br>    },<br>    "web_bo_db_schema": {<br>      "name": "web-bo-db-schema-pipelines",<br>      "pipeline_yml_filename": "web-bo-db-schema-pipelines.yml"<br>    }<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "nodo"<br>  }<br>}</pre> | no |
| <a name="input_observability_iac"></a> [observability\_iac](#input\_observability\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "observability-infrastructure",<br>    "pipeline_name_prefix": "observability-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "observability"<br>  }<br>}</pre> | no |
| <a name="input_pay_wallet_iac"></a> [pay\_wallet\_iac](#input\_pay\_wallet\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "pay-wallet-infrastructure",<br>    "pipeline_name_prefix": "pay-wallet-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "pay-wallet"<br>  }<br>}</pre> | no |
| <a name="input_qi_iac"></a> [qi\_iac](#input\_qi\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "qi-infrastructure",<br>    "pipeline_name_prefix": "qi-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "qi"<br>  }<br>}</pre> | no |
| <a name="input_receipts_iac"></a> [receipts\_iac](#input\_receipts\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "receipts-infrastructure",<br>    "pipeline_name_prefix": "receipts-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "receipts"<br>  }<br>}</pre> | no |
| <a name="input_selfcare_iac"></a> [selfcare\_iac](#input\_selfcare\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "selfcare-infrastructure",<br>    "pipeline_name_prefix": "selfcare-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "selfcare"<br>  }<br>}</pre> | no |
| <a name="input_shared_iac"></a> [shared\_iac](#input\_shared\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable_code_review": true,<br>    "enable_deploy": true,<br>    "path": "shared-infrastructure",<br>    "pipeline_name_prefix": "shared-infra"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "pagopa-infra",<br>    "organization": "pagopa",<br>    "pipelines_path": ".devops",<br>    "yml_prefix_name": "shared"<br>  }<br>}</pre> | no |
| <a name="input_switcher_iac"></a> [switcher\_iac](#input\_switcher\_iac) | n/a | `map` | <pre>{<br>  "pipeline": {<br>    "enable": false,<br>    "path": "switcher"<br>  },<br>  "repository": {<br>    "branch_name": "refs/heads/main",<br>    "name": "eng-common-scripts",<br>    "organization": "pagopa",<br>    "pipelines_path": "devops",<br>    "yml_prefix_name": null<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
