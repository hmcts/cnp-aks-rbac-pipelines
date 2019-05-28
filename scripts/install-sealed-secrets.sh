#!/bin/bash
set -ex

VAULT_NAME=$1
VERSION=${2:-1.0.1}
NAMESPACE=${3:-admin}

az keyvault secret download \
  --file sealed-secrets-pki.yaml \
  --name sealed-secrets-pki \
  --encoding ascii \
  --vault-name ${VAULT_NAME}

kubectl apply -f sealed-secrets-pki.yaml

helm upgrade sealed-secrets stable/sealed-secrets --version ${VERSION} --install --recreate-pods --namespace ${NAMESPACE} --set secretName=sealed-secrets-pki --wait

