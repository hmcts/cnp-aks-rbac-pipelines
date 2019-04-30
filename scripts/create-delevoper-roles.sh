#!/bin/bash
set -e

ROLES_YAML=${1:-templates/repositories.yaml}
BINDING_YAML=${2:-roles/developers-log-reader-binding.yaml}

kubectl apply -f ${ROLES_YAML}
DEVELOPERS_GROUP=$(az ad group list --query  "[?displayName=='developers'].objectId" -o tsv)
if [ ! -z "${DEVELOPERS_GROUP}" ]; then          
    cat ${BINDING_YAML} | sed -e 's@${DEVELOPERS_GROUP}@'"$DEVELOPERS_GROUP"'@' | kubectl apply -f -
fi