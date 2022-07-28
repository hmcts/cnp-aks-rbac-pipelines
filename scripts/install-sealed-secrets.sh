#!/bin/bash
set -ex

VAULT_NAME=$1
VERSION=$2
NAMESPACE=$3

az keyvault secret download \
  --file sealed-secrets-pki.yaml \
  --name sealed-secrets-pki \
  --encoding ascii \
  --vault-name ${VAULT_NAME}

kubectl apply -f sealed-secrets-pki.yaml

helm repo add bitnami-labs https://bitnami-labs.github.io/sealed-secrets/
helm upgrade sealed-secrets bitnami-labs/sealed-secrets --version 2.1.6 --install --namespace ${NAMESPACE} \
     -f  deployments/sealed-secrets/values.yaml --set secretName=sealed-secrets-pki --wait \
