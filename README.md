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
The continous integration triggers on YAML push have been __disabled__. The pipelines are queued on demand.
