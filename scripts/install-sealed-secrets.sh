#!/bin/bash
set -ex

VAULT_NAME=$1
VERSION=$2
NAMESPACE=$3
ENABLE_HELM_TLS=$4

az keyvault secret download \
  --file sealed-secrets-pki.yaml \
  --name sealed-secrets-pki \
  --encoding ascii \
  --vault-name ${VAULT_NAME}

kubectl apply -f sealed-secrets-pki.yaml

if [[ ${ENABLE_HELM_TLS} == true ]]
then
 helm_tls_params+=(--tls --tls-ca-cert scripts/ca.cert.pem --tls-cert scripts/helm.cert.pem --tls-key scripts/helm.key.pem )
fi

helm upgrade sealed-secrets stable/sealed-secrets --version ${VERSION} --install --recreate-pods --namespace ${NAMESPACE} \
    --set secretName=sealed-secrets-pki --wait \
     "${helm_tls_params[@]}"

