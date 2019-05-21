#!/bin/bash
set -e

SUBSCRIPTION_NAME=$1

BINDING_YAML=${1:-roles/developers-log-reader-role.yaml}

kubectl apply -f ${BINDING_YAML} --validate=false
DEVELOPERS_GROUP=$(az ad group list --query  "[?displayName=='dcd_group_aks_user_${SUBSCRIPTION_NAME,,}_v2'].objectId" -o tsv)
if [ ! -z "${DEVELOPERS_GROUP}" ]; then
    cat ${BINDING_YAML} | sed -e 's@${DEVELOPERS_GROUP}@'"$DEVELOPERS_GROUP"'@' | kubectl apply -f -
fi
