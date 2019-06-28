#!/bin/bash
set -e


AKS_ID=$1
WORKSPACE_RG=$2
WORKSPACE_NAME=$3

WORKSPACE_ID=$(az resource list --resource-group ${WORKSPACE_RG} --subscription DCD-CFTAPPS-SBOX --name ${WORKSPACE_NAME} --resource-type Microsoft.OperationalInsights/workspaces --query [0].id -o tsv)

az monitor diagnostic-settings create \
    -n DiagLogAnalytics \
    --resource ${AKS_ID} \
    --workspace ${WORKSPACE_ID} \
    --logs '[{"category":"kube-apiserver","Enabled":true},{"category":"kube-controller-manager","Enabled":true},{"category":"cluster-autoscaler","Enabled":true},{"category":"kube-scheduler","Enabled":true},{"category":"kube-audit","Enabled":true}]' \
    --metrics '[{"category":"AllMetrics","enabled":true,"retentionPolicy":{"days":30,"enabled":true}}]'