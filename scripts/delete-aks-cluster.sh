#!/bin/bash
set -ex

RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2

NODE_RG=$(az aks show -n ${CLUSTER_NAME} -g ${RESOURCE_GROUP_NAME} --query 'nodeResourceGroup' -o tsv)

LOCKS=$(az group lock list -g $NODE_RG --query '[].name' -o json -o tsv)

for RG_LOCK in ${LOCKS[@]};
do
  az lock delete --name $RG_LOCK --resource-group $NODE_RG
done

az aks delete -g ${RESOURCE_GROUP_NAME} -n ${CLUSTER_NAME} -y