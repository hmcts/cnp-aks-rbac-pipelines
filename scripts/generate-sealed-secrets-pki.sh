#!/bin/bash
set -e

VAULT_NAME=$1
NAMESPACE=${2:-admin}

openssl req -x509 -newkey rsa:4096 -keyout tls.key -out tls.crt -days 365 \
  -subj "/C=GB/ST=London/L=London/O=Ministry of Justice/OU=HMCTS/CN=sealed-secrets.platform.hmcts.net" -nodes

kubectl create secret generic sealed-secrets-pki \
  --from-file=tls.key \
  --from-file=tls.crt \
  --namespace ${NAMESPACE} --dry-run -o yaml > sealed-secrets-pki.yaml

az keyvault secret set \
  --name sealed-secrets-pki \
  --description sealed-secrets-pki \
  --file sealed-secrets-pki.yaml \
  --encoding ascii \
  --vault-name ${VAULT_NAME}