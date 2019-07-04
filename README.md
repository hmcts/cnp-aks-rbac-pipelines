# AKS RBAC Enabled Cluster Pipelines 

## Introduction

Included here are the scripts requires by the manually configured build and release pipeline in Azure DevOps for creating AKS clusters

## Why manual?
Currently Azure DevOps is missing some features for release pipelines through code
* re-running just one stage / environment
* gates / approvals (not strictly required)
* step templates / task groups

Once there is an easy way to target just one environment, and we can reuse code rather than copying it for each stage we should migrate to config as code.



### Flux install
|Type|Activity|Subscription|Script|
|-|-|-|-|
|Bash|Flux create secret|N|Y|
|Bash|Flux install|N|Y|

### Flux post-install
|Type|Activity|Subscription|Script|
|-|-|-|-|
|Download secure file|Download secure file|N|N|
|Bash|Create github secret|N|Y|

### Metrics

|Type|Activity|Subscription|Script|
|-|-|-|-|
ARM|Add Default Metric Alerts|Y|N|
ARM|Add Custom Metric Alerts|Y|N|


## Usage Guidelines

### Variable Groups

As maintaining Variable groups in UI is tedious, all AKS pipeline variable groups are managed as code in here.

* To update repository with variable groups if changed through UI, run [Get All Script][variablegroups/scripts/get-all-variable-groups.sh] with a Personal Access Token.
* Pipeline uses [Update Script][variablegroups/scripts/update-variable-groups.sh] to update all variable groups in [Variable Groups][variablegroups/] while building master branch.
* To create a new environment, copy and rename [SBOX-AKS-COMMON.json][variablegroups/SBOX-AKS-COMMON.json] ,[SBOX-AKS-Tags.json][variablegroups/SBOX-AKS-Tags.json], [SBOX-AKS-KeyVault.json][variablegroups/SBOX-AKS-KeyVault.json] . Fill all fields with appropriate values before raising a PR.
* You can get serviceEndpointId for keyvault variablegroup by running [Get Service End point Id script][variablegroups/scripts/get-service-end-point.sh] . If you don't have necessary privileges to list service connections, ask someone who has it. 
* Refer [here][https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate] for generating personal access token to authenticate Azure Devops.  

