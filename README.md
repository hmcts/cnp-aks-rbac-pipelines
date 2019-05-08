# AKS RBAC Enabled Cluster Pipelines

## Introduction

Collection of pipelines that automate the recreation of the AKS RBAC enabled clusters.
In general, the pipelines do the following:
* Fetch required configuration from various sources (keyvault, az cli queries)
* Check if the infrastructure for the parameters passed in does already exist; if not, the necessary infrastructure components are created.
* Create the cluster
* Assign RBAC roles to the cluster (Global admin, Cluster admin and Developer roles)
* Run the tests

### Pipelines
Each pipeline has a folder in which all YAML files, scripts and other related content will be self contained.

### Triggers
The continuous integration triggers on YAML push have been __disabled__. The pipelines are queued on demand.


---

# Subscription dependencies

## Monitoring

|Type|Activity|Subscription|Script|
|-|-|-|-|
|ARM|Deploy Monitoring|Y|N|
|Bash|Parse output|N|Y|

## Original Deploy AKS

|Type|Activity|Subscription|Script|
|-|-|-|-|
|Azure Cli|Check VNET|Y|Y|
|ARM|Deploy VNET|Y|N|
|Bash|Parse output|N|Y|
|ARM|Deploy AKS Cluster|Y|N|
|Bash|Parse output|N|Y|
|Azure Cli|Get AKS token|Y|Y|
|Azure Cli|Enable monitoring|Y|Y|
|Bash|Create Namespaces|N|Y|
|Bash|Template Secret|N|Y|
|Azure Cli|Bind admin|Y|Y|
|Azure Cli|Bind dev|Y|Y|
|ARM|Create Managed identity|Y|N|
|Bash|Parse output|N|Y|
|Azure Cli|Permissions MI|Y|Y|
|Helm|Install Helm|N|N|
|Azure Cli|Install Tiller MI|Y|Y|
|Bash|Flux create secret|N|Y|
|Bash|Flux install|N|Y|
|Download secure file|Download secure file|N|N|
|Bash|Create github secret|N|Y|
ARM|Add Default Metric Alerts|Y|N|
ARM|Add Custom Metric Alerts|Y|N|


## Re-shape Deploy AKS

### VNET
   
|Type|Activity|Subscription|Script|
|-|-|-|-|
|Azure Cli|Check VNET|Y|Y|
|ARM|Deploy VNET|Y|N|
|Bash|Parse output|N|Y|

### AKS Cluster
|Type|Activity|Subscription|Script|
|-|-|-|-|
|ARM|Deploy AKS Cluster|Y|N|
|Bash|Parse output|N|Y|
|Azure Cli|Get AKS token|Y|Y|
|Azure Cli|Enable monitoring|Y|Y|
|Bash|Create Namespaces|N|Y|
|Bash|Template Secret|N|Y|
|Azure Cli|Bind admin|Y|Y|
|Azure Cli|Bind dev|Y|Y|

### AKS Cluster post-install
|Type|Activity|Subscription|Script|
|-|-|-|-|
|ARM|Create Managed identity|Y|N|
|Bash|Parse output|N|Y|
|Azure Cli|Permissions MI|Y|Y|

### Helm install
|Type|Activity|Subscription|Script|
|-|-|-|-|
|Helm|Install Helm|N|N|
|Azure Cli|Install Tiller MI|Y|Y|

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


