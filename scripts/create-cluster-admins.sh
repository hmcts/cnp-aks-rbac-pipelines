#!/bin/bash
set -e

SUBSCRIPTION_NAME=$1
CLUSTER_ADMIN_BINDING=${2:-roles/cluster-admin-role-binding.yaml}

CLUSTER_GLOBAL_ADMINS_GROUP=$(az ad group list --query  "[?displayName=='dcd_group_aks_admin_global_v2'].objectId" -o tsv)

CLUSTER_ADMINS_GROUP_NAME="dcd_group_aks_admin_${SUBSCRIPTION_NAME,,}_v2"
CLUSTER_ADMIN_GROUP=$(az ad group list --query  "[?displayName=='${CLUSTER_ADMINS_GROUP_NAME}'].objectId" -o tsv)
if [ -z "${CLUSTER_ADMIN_GROUP}" ]; then
    echo "Cluster admin group doesn't exist, aborting"
    exit 1
fi

cat ${CLUSTER_ADMIN_BINDING} | \
    sed -e 's@${CLUSTER_ADMIN_GROUP}@'"$CLUSTER_ADMIN_GROUP"'@' | \
    sed -e 's@${CLUSTER_GLOBAL_ADMINS_GROUP}@'"$CLUSTER_GLOBAL_ADMINS_GROUP"'@' | \
    kubectl apply -f -