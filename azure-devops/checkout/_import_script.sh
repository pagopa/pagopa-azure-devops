#!/bin/bash

bash terraform.sh init checkout

### pagopa-proxy import

# bash terraform.sh import checkout 'module.pagopa-proxy_code_review[0].azuredevops_build_definition.pipeline' 'ffd7c346-c610-46c5-969c-a1b518de20bb/566'
# bash terraform.sh import checkout 'module.pagopa-proxy_deploy[0].azuredevops_build_definition.pipeline' 'ffd7c346-c610-46c5-969c-a1b518de20bb/589'
# bash terraform.sh import checkout 'module.pagopa-checkout-tests_code_review[0].azuredevops_build_definition.pipeline' 'ffd7c346-c610-46c5-969c-a1b518de20bb/564'
# bash terraform.sh import checkout 'module.pagopa-checkout-fe_code_review[0].azuredevops_build_definition.pipeline' 'ffd7c346-c610-46c5-969c-a1b518de20bb/573'
# bash terraform.sh import checkout 'module.pagopa-checkout-fe_deploy[0].azuredevops_build_definition.pipeline' 'ffd7c346-c610-46c5-969c-a1b518de20bb/584'



### rm in old state
# terraform state rm 'module.pagopa-proxy_code_review[0].azuredevops_build_definition.pipeline'
# terraform state rm 'module.pagopa-proxy_deploy[0].azuredevops_build_definition.pipeline'
# terraform state rm 'module.pagopa-checkout-tests_code_review[0].azuredevops_build_definition.pipeline'
# terraform state rm 'module.pagopa-checkout-fe_code_review[0].azuredevops_build_definition.pipeline'
# terraform state rm 'module.pagopa-checkout-fe_deploy[0].azuredevops_build_definition.pipeline'

