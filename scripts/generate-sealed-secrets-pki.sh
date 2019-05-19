#!/bin/bash
set -e

VAULT_NAME=$1

openssl req -x509 -newkey rsa:4096 -keyout tls.key -out tls.crt -days 365 \
  -subj "/C=US/ST=Oregon/L=Portland/O=Company Name/OU=Org/CN=www.example.com" -nodes

kubectl create secret generic sealed-secrets-pki \
  --from-file=tls.key \
  --from-file=tls.crt \
  --namespace admin --dry-run -o yaml > sealed-secrets-pki.yaml

az keyvault secret set \
  --name sealed-secrets-pki \
  --description sealed-secrets-pki \
  --file sealed-secrets-pki.yaml \
  --encoding ascii \
  --vault-name ${VAULT_NAME}