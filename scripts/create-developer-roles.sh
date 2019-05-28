#!/bin/bash
set -e

BINDING_YAML=${1:-roles/reader-role-binding.yaml}
AKS_USER_GROUP_PREFIX=${2:-dcd_group_aks_user_}

SUBSCRIPTION_NAME=$(az account show --query name -o tsv)

kubectl apply -f ${BINDING_YAML} --validate=false
DEVELOPERS_GROUP=$(az ad group list --query "[?displayName=='${AKS_USER_GROUP_PREFIX}${SUBSCRIPTION_NAME,,}_v2'].objectId" -o tsv)
cat ${BINDING_YAML} | sed -e 's@${DEVELOPERS_GROUP}@'"${DEVELOPERS_GROUP}"'@' | kubectl apply -f -
