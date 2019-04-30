#!/bin/bash
set -e

CLUSTER_NAME=$1
CLUSTER_ADMIN_BINDING=${2:-roles/cluster-admin-role-binding.yaml}

CLUSTER_GLOBAL_ADMINS_GROUP=$(az ad group list --query  "[?displayName=='aks-cluster-admins'].objectId" -o tsv)

CLUSTER_ADMINS_GROUP_NAME="${CLUSTER_NAME}-cluster-admins"
CLUSTER_ADMIN_GROUP=$(az ad group list --query  "[?displayName=='${CLUSTER_ADMINS_GROUP_NAME}'].objectId" -o tsv)
if [ -z "${CLUSTER_ADMIN_GROUP}" ]; then 
    echo "Cluster admin group doesn't exist, creating"
    CLUSTER_ADMIN_GROUP=$(az ad group create  --display-name ${CLUSTER_ADMINS_GROUP_NAME} --mail-nickname ${CLUSTER_ADMINS_GROUP_NAME} --query objectId -o tsv)
fi

cat ${CLUSTER_ADMIN_BINDING} | \
    sed -e 's@${CLUSTER_ADMIN_GROUP}@'"$CLUSTER_ADMIN_GROUP"'@' | \
    sed -e 's@${CLUSTER_GLOBAL_ADMINS_GROUP}@'"$CLUSTER_GLOBAL_ADMINS_GROUP"'@' | \
    kubectl apply -f -