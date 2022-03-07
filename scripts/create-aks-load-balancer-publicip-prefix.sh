#!/bin/bash
set -e

RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2
#creating it ahead of aks arm template as arm template doesn't validate very well.

#deleting with arm template.
#az network public-ip delete --name ${CLUSTER_NAME}-pip --resource-group ${RESOURCE_GROUP_NAME}

#creating it ahead of aks arm template as arm template doesn't validate very well.
az network public-ip prefix create --length 28 --name ${CLUSTER_NAME}-pip --resource-group ${RESOURCE_GROUP_NAME} --zone 1, 2, 3