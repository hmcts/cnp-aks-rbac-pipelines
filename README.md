# AKS RBAC Enabled Cluster Pipelines 

## Introduction

Included here are the scripts requires by the manually configured build and release pipeline in Azure DevOps for creating AKS clusters

## Why manual?

Azure DevOps has evolved since this started, and now should support the features we require, we just haven't had the time to convert it over
to pipeline as code.

The only remaining open question is about rolling changes out environment by environment,
currently it's done by clicking the 'Deploy' button for the environment in the release pipeline.

## Usage Guidelines

### Variable Groups

As maintaining Variable groups in UI is tedious, all AKS pipeline variable groups are managed as code in here.

* To update repository with variable groups if changed through UI, run [Get All Script](variablegroups/scripts/get-all-variable-groups.sh) with a Personal Access Token.
* Pipeline uses [Update Script](variablegroups/scripts/update-variable-groups.sh) to update all variable groups in [Variable Groups](variablegroups/) while building master branch.
* To create a new environment, copy and rename [SBOX-AKS-COMMON.json](variablegroups/SBOX-AKS-COMMON.json) ,[SBOX-AKS-Tags.json](variablegroups/SBOX-AKS-Tags.json), [SBOX-AKS-KeyVault.json](variablegroups/SBOX-AKS-KeyVault.json) . Fill all fields with appropriate values before raising a PR.
* You can get serviceEndpointId for keyvault variablegroup by running [Get Service End point Id script](variablegroups/scripts/get-service-end-point.sh) . If you don't have necessary privileges to list service connections, ask someone who has it. 
* Refer [here](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) for generating personal access token to authenticate Azure Devops.  

### Updating Kubernetes version

We regularly update the version of Kubernetes we run, and try to keep all clusters on the same version.

The aim is to stay on the latest GA version of Kubernetes that Microsoft supports.

We sometimes run the preview environment on newer versions so that we can try out new features and as a 'canary'
to make sure that it works with our workloads. Make sure you test the non live preview cluster, works first before promoting it.

The version is managed in a per environment [vars file](templates/vars/aks).

Once you've updated the version use the [AKS release pipeline](https://dev.azure.com/hmcts/CNP/_release?_a=releases&view=mine&definitionId=16) to apply the update.

_Note: You will need to raise a change request to do this in production, do the other environments first and then raise the change once they are successful._
