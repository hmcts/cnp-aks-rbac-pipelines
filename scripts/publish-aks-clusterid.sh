#!/bin/bash
set -e

CLUSTER_NAME=$1
RESOURCE_GROUP_NAME=$2

aksID=$( az resource list --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query "[?type=='Microsoft.ContainerService/managedClusters']" | jq '.[0].id')
echo "##vso[task.setvariable variable=aksid]${aksID}"