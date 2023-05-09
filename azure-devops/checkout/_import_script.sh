#!/bin/bash

bash terraform.sh init prod

### pagopa-proxy import

# bash terraform.sh import checkout 'module.pagopa-proxy_code_review[0].azuredevops_build_definition.pipeline' 'ffd7c346-c610-46c5-969c-a1b518de20bb/566
# bash terraform.sh import checkout 'module.pagopa-proxy_deploy[0].azuredevops_build_definition.pipeline' 'ffd7c346-c610-46c5-969c-a1b518de20bb/589

### rm in old state
# terraform state rm 'module.pagopa-proxy_code_review[0].azuredevops_build_definition.pipeline'
# terraform state rm 'module.pagopa-proxy_deploy[0].azuredevops_build_definition.pipeline'

