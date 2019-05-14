#!/bin/bash
set -e

VAULT_NAME=$1

az keyvault secret download \
  --file sealed-secrets-pki.yaml \
  --name sealed-secrets-pki \
  --encoding ascii \
  --vault-name ${VAULT_NAME}

kubectl apply -f sealed-secrets-pki.yaml

helm upgrade sealed-secrets stable/sealed-secrets --version 1.0.1 --install --namespace admin --set secretName=sealed-secrets-pki --wait

