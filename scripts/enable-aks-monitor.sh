#!/bin/bash
set -e


AKS_ID=$1
WORKSPACE_ID=$2

az monitor diagnostic-settings create \
    -n DiagLogAnalytics \
    --resource ${AKS_ID} \
    --workspace ${WORKSPACE_ID} \
    --logs '[{"category":"kube-apiserver","Enabled":true},{"category":"kube-controller-manager","Enabled":true},{"category":"cluster-autoscaler","Enabled":true},{"category":"kube-scheduler","Enabled":true},{"category":"kube-audit-admin","Enabled":true}]' \
    --metrics '[{"category":"AllMetrics","enabled":true,"retentionPolicy":{"days":30,"enabled":true}}]'
