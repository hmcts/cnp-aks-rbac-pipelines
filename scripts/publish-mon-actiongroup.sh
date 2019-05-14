#!/bin/bash
set -e

AG_NAME=$1
RESOURCE_GROUP_NAME=$2

actionGroupID=$( az resource list --name ${AG_NAME} --resource-group ${RESOURCE_GROUP_NAME} --query "[?type=='Microsoft.Insights/actionGroups']" | jq '.[0].id')
echo "##vso[task.setvariable variable=actionGroupID]${aksID}"