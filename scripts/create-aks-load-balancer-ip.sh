#!/bin/bash
set -e

RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2
#creating it ahead of aks arm template as arm template doesn't validate very well.
az network public-ip create --name ${CLUSTER_NAME}-pip --resource-group ${RESOURCE_GROUP_NAME} --sku Standard