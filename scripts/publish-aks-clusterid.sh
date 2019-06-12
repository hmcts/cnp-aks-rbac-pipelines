#!/bin/bash
set -e

CLUSTER_NAME=$1
RESOURCE_GROUP_NAME=$2

aksID=$(az aks show --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query id -o tsv)
echo "##vso[task.setvariable variable=aksid]${aksID}"
