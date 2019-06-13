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


