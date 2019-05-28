#!/bin/bash
# Adds service principal credentials to flux so that it can pull from our container registry
set -e

ACR_NAME=$1
AKS_SP_ID=$2
AKS_SP_SECRET=$3
REPOSITORIES_YAML=${4:-templates/repositories.yaml}

sed -i -e 's/${ACR_NAME}/'"${ACR_NAME}"'/g' \
       -e 's@${ACR_SERVICE_PRINCIPAL_ID}@'"${AKS_SP_ID}"'@' \
       -e 's@${ACR_SERVICE_PRINCIPAL_SECRET}@'"${AKS_SP_SECRET}"'@' \
           ${REPOSITORIES_YAML}    
