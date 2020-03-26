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

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm upgrade sealed-secrets stable/sealed-secrets --version ${VERSION} --install --namespace ${NAMESPACE} \
     -f  deployments/sealed-secrets/values.yaml --set secretName=sealed-secrets-pki --wait \
