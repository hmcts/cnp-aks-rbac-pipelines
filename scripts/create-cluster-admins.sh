#!/bin/bash
set -ex

CLUSTER_ADMIN_BINDING=${1:-roles/cluster-admin-role-binding.yaml}
AAD_ADMIN_GROUP_NAME=${2:-dcd_group_aks_admin_global_v2}
CLUSTER_ADMINS_GROUP_PREFIX=${3:-dcd_group_aks_admin_}

SUBSCRIPTION_NAME=$(az account show --query name --verbose -o tsv)
CLUSTER_GLOBAL_ADMINS_GROUP=$(az ad group list --query "[?displayName=='${AAD_ADMIN_GROUP_NAME}'].objectId" --verbose -o tsv)
CLUSTER_ADMINS_GROUP_NAME="${CLUSTER_ADMINS_GROUP_PREFIX}${SUBSCRIPTION_NAME,,}_v2"
CLUSTER_ADMIN_GROUP=$(az ad group list --query "[?displayName=='${CLUSTER_ADMINS_GROUP_NAME}'].objectId" --verbose -o tsv)

if [ -z "${CLUSTER_ADMIN_GROUP}" ]; then
    echo "Cluster admin group doesn't exist, aborting"
    exit 1
fi

cat ${CLUSTER_ADMIN_BINDING} | \
    sed -e 's@${CLUSTER_ADMIN_GROUP}@'"$CLUSTER_ADMIN_GROUP"'@' | \
    sed -e 's@${CLUSTER_GLOBAL_ADMINS_GROUP}@'"$CLUSTER_GLOBAL_ADMINS_GROUP"'@' | \
    kubectl apply -f -